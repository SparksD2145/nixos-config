{
  inputs,
  ...
}:
let
  x86_64-linux = import ./x86_64-linux { inherit inputs; };
in
(x86_64-linux // { })
