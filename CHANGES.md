# v0.3.0

* Add new if%true that is a if expression that returns the value of the condition.

* Refactor let%if. Error locations are slightly different.

# v0.2.0

* Remove references to jbuilder and switch to dune completely

* Do not mute warnings for unused variables.
  If your let%if pattern matches all cases you should just use a regular let binding.

# v0.1.0

* Initial release!
