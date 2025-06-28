let
  system = "age1cl08ztyu3ksl06h8sy54jvwdk2qeh0nhs3uq9sr8rtypghjks5uquawzwp";
in
{
  "home-manager/secrets/kubeconfig.age".publicKeys = [ system ];
}
