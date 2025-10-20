{
  inputs,
  ...
}:
let
  workstations = import ./workstations { inherit inputs; };
  servers = import ./servers { inherit inputs; };
in
(workstations // servers // { })
