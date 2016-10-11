sub(x, y) => x - y;
add(x, y) => x + y;
div(x, y) => x / y;
mod(x, y) => x % y;
mul(x, y) => x * y;
not(x) => !x;
lt(x, y) => x < y;
gt(x, y) => x > y;
lteq(x, y) => x <= y;
gteq(x, y) => x >= y;
eq(x, y) => x == y;

rpc_proxy(name, arguments) {
  print ("rpc_proxy eval: $name ($arguments)");
}
