(*****************************************************************************)
(*                                                                           *)
(* Open Source License                                                       *)
(* Copyright (c) 2019 Nomadic Labs <contact@nomadic-labs.com>                *)
(*                                                                           *)
(* Permission is hereby granted, free of charge, to any person obtaining a   *)
(* copy of this software and associated documentation files (the "Software"),*)
(* to deal in the Software without restriction, including without limitation *)
(* the rights to use, copy, modify, merge, publish, distribute, sublicense,  *)
(* and/or sell copies of the Software, and to permit persons to whom the     *)
(* Software is furnished to do so, subject to the following conditions:      *)
(*                                                                           *)
(* The above copyright notice and this permission notice shall be included   *)
(* in all copies or substantial portions of the Software.                    *)
(*                                                                           *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR*)
(* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  *)
(* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   *)
(* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER*)
(* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING   *)
(* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER       *)
(* DEALINGS IN THE SOFTWARE.                                                 *)
(*                                                                           *)
(*****************************************************************************)
open Protocol
open Alpha_context
open Protocol_client_context

(** Retreive the manager key in a contract storage.
    The storage has to be of type `pair key_hash 'a`.
*)
val get_contract_manager :
  #full -> Contract.t -> public_key_hash tzresult Lwt.t

(** Set the delegate of a manageable contract.
    For a contract with a `do`entrypoint, it builds the lamba that set
    the provided delegate.
    `~source` has to be the registered manager of the contract.
*)
val set_delegate :
  #Protocol_client_context.full ->
  chain:Chain_services.chain ->
  block:Block_services.block ->
  ?confirmations:int ->
  ?dry_run:bool ->
  ?verbose_signing:bool ->
  ?branch:int ->
  fee_parameter:Injection.fee_parameter ->
  ?fee:Tez.t ->
  source:public_key_hash ->
  src_pk:public_key ->
  src_sk:Client_keys.sk_uri ->
  Contract.t ->
  public_key_hash option ->
  Kind.transaction Kind.manager Injection.result tzresult Lwt.t

(** Perform a transfer on behalf of a managed contract .
    For a contract with a `do`entrypoint, it builds the lamba that
    does the requested operation.
    `~source` has to be the registered manager of the contract.
*)
val transfer :
  #Protocol_client_context.full ->
  chain:Chain_services.chain ->
  block:Block_services.block ->
  ?confirmations:int ->
  ?dry_run:bool ->
  ?verbose_signing:bool ->
  ?branch:int ->
  source:public_key_hash ->
  src_pk:public_key ->
  src_sk:Client_keys.sk_uri ->
  contract:Contract.t ->
  destination:Contract.t ->
  ?entrypoint:string ->
  ?arg:string ->
  amount:Tez.t ->
  ?fee:Tez.t ->
  ?gas_limit:counter ->
  ?storage_limit:counter ->
  ?counter:counter ->
  fee_parameter:Injection.fee_parameter ->
  unit ->
  (Kind.transaction Kind.manager Injection.result * Contract.t list) tzresult
  Lwt.t