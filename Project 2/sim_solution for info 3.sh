#! /bin/bash

grep -i ^[[:space:]]*component[[:space:]] riscv_cpu.vhd | awk '{print $2}' > component_names.txt

declare -a start_str
start_str=(`cat "component_names.txt"`)

grep -n ^[[:space:]]*component[[:space:]] riscv_cpu.vhd | cut -d ":" -f 1 > start.txt

grep -n ^[[:space:]]*end[[:space:]]component riscv_cpu.vhd | cut -d ":" -f 1 > end.txt

#cat start.txt

#cat end.txt
x=$(wc -l < start.txt)

declare -a start
start=(`cat "start.txt"`)

declare -a end
end=(`cat "end.txt"`)



for ((i=0;i<$x;i=i+1))
do
  pin_count=$(head -"${end[$i]}" riscv_cpu.vhd | tail +"${start[$i]}" | egrep -c -i -w -e "in" -e "out")
  pin_in=$(head -"${end[$i]}" riscv_cpu.vhd | tail +"${start[$i]}" | egrep -c -i -w "in")
  pin_out=$(head -"${end[$i]}" riscv_cpu.vhd | tail +"${start[$i]}" | egrep -c -i -w "out")
  echo "Component ${start_str[$i]} has $pin_count pins with $pin_in number of inputs and $pin_out number of outputs" >> pin_info.txt
done

rm start.txt
rm end.txt
rm component_names.txt
