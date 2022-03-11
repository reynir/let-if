# let%if is if let backwards

This ppx adds a construct similar to `let if` in Rust.
The following two snippets are equivalent:

```OCaml
let%if Some x = Sys.getenv_opt "HELLO" in
print_endline x
```

```OCaml
match Sys.getenv_opt "HELLO" with
| Some x -> print_endline x
| _ -> ()
```

# New: if%true then do

Do you often want to perform side effects if an expression is true while still returning the boolean value?
Then `if%true` is for you!
Simply write:

```OCaml
if%true cond then something else otherwise
```

... and your code is automagically transformed into:

```OCaml
let c = cond in (if c then something else otherwise); c
```

The else branch is optional!
