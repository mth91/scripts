#! /bin/bash

# first part of the basic structure of the gnuplot-input file
echo "set title 'Difference-Spectrum'" >> buffer
echo "set grid" >> buffer
#echo "set key outside top" >> buffer
echo "unset key" >> buffer
echo "set palette rgbformulae 33,13,10" >> buffer
echo "unset colorbox" >> buffer
echo "set xlabel 'Wavenumber (cm^-1)'" >> buffer
echo "set ylabel 'Intensity'" >> buffer
echo -n "plot " >> buffer

# generate numb_dat, which is needed for determining the color palette and copy all
# IR-spectra from the parent directory to the current folder
numb_dat=-1

for i in *.dat
do
	let numb_dat=numb_dat+1
	cp $i .
done

# we need these variables for the generation and the full exhaustion of the color palette
color=$(echo "1 / $numb_dat " | bc -l)
counter=1

for i in ir-tr2-u-[0-9]*-prot.dat
do
	echo $i
	paste ir-tr2-u-000-prot.dat $i | awk '{ printf ("%s %.5f\n", $1, ($4-$2));}' > $i.subtr
	mv $i.subtr $(echo $i.subtr | sed 's/.dat.subtr/.txt/g' )
done


# finish the gnuplot input file
for i in *.txt
do
	farbcode=$(echo "( 1 - $color * $counter )" | bc -l)
	title=`echo $i | sed s/.txt//`
        echo -n "'$i' title '$title' with line lc palette frac $farbcode, " >> buffer

	let counter=counter+1
done

echo -e "\nset term png" >> buffer
echo "set output 'Difference-Spectrum.png'" >> buffer
echo "replot" >> buffer
echo "pause -1" >> buffer

grep -A15 "set title" buffer | sed -e s/', $'// -e s/"''"/"'---'"/ > gnuplot.file

rm buffer

gnuplot gnuplot.file
