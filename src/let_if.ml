open Ppxlib
open Ast_builder.Default

let expand_let ~ctxt:_ rec_flag bindings expression =
  match rec_flag with
  | { txt = Recursive; loc } ->
    Location.raise_errorf ~loc "[%%if ] cannot apply to a recursive let-binding"
  | { txt = Nonrecursive; loc = _ } ->
    match bindings with
    | [{ pvb_pat; pvb_expr; pvb_attributes = _; pvb_loc = loc }] ->
      [%expr match [%e pvb_expr] with
          | [%p pvb_pat] -> [%e expression]
          | _ -> () ]
    | _ :: { pvb_loc = loc; _ } :: _ ->
      Location.raise_errorf ~loc "[%%if ] cannot apply to let-and bindings"
    | [] -> assert false

let let_if : Extension.t =
  Extension.V3.declare "if"
    Extension.Context.Expression
    Ast_pattern.(single_expr_payload (pexp_let __' __ __))
    expand_let

let expand_if ~ctxt:_ if_ then_ else_ =
  let c = gen_symbol () in
  let loc = if_.pexp_loc in
  match else_ with
  | Some else_ ->
    [%expr let [%p pvar ~loc c] = [%e if_] in
      (if [%e evar ~loc c] then [%e then_] else [%e else_]);
      [%e evar ~loc c] ]
  | None ->
    [%expr let [%p pvar ~loc c] = [%e if_] in
      (if [%e evar ~loc c] then [%e then_]);
      [%e evar ~loc c] ]

let if_true : Extension.t =
  Extension.V3.declare "true"
    Extension.Context.Expression
    Ast_pattern.(single_expr_payload (pexp_ifthenelse __ __ __))
    expand_if

let extensions = [
  let_if;
  if_true;
]

let () =
  Ppxlib.Driver.register_transformation "let-if"
    ~extensions
