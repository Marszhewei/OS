layout split

set disassemble-next-line on
set print pretty on
set print array on
set print array-indexes on

b _start

target remote : 1234

c

focus cmd
