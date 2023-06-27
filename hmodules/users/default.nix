{ myLib, username, hostname, ... }:
  {
    imports = with myLib; (moduleImport ./. username)
      ++ (moduleImport ./. "${username}@${hostname}");
  }
