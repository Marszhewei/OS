layout src

set disassemble-next-line on
set print pretty on
set print array on
set print array-indexes on

b _start
b start_kernel

target remote : 1234

c

focus cmd
