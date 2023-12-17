lib: _:
  with lib;
  with types;
  {
    types = {
      listOfOrSingleton = t: coercedTo (either (listOf t) t) toList (listOf t);
    };
  }
