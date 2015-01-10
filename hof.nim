proc double(x : int) : int =
  x + x 
let xs = @[1, 2, 4, 8, 16, 32, 64, 128, 256]
echo xs.map(double)
