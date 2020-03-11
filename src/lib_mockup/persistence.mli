(*****************************************************************************)
(*                                                                           *)
(* Open Source License                                                       *)
(* Copyright (c) 2020 Nomadic Labs, <contact@nomadic-labs.com>               *)
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

(** Returns a mockup environment for the default protocol (which is the first
    in the list of registered protocol, cf [Registration] module). *)
val default_mockup_context :
  unit ->
  (Registration.mockup_environment * Tezos_protocol_environment.rpc_context)
  tzresult
  Lwt.t

(**  Returns a mockup environment for the specified protocol hash. *)
val init_mockup_context_by_protocol_hash :
  Protocol_hash.t ->
  (Registration.mockup_environment * Tezos_protocol_environment.rpc_context)
  tzresult
  Lwt.t

(** Load a mockup environment and initializes a protocol RPC context from
    a mockup base directory. *)
val get_mockup_context_from_disk :
  base_dir:string ->
  (Registration.mockup_environment * Tezos_protocol_environment.rpc_context)
  tzresult
  Lwt.t

(** Initializes an on-disk mockup environment in [base_dir] for the specified
    protocol. *)
val create_mockup :
  protocol_hash:Protocol_hash.t -> base_dir:string -> unit tzresult Lwt.t

(** Overwrites an on-disk mockup environment. *)
val overwrite_mockup :
  protocol_hash:Protocol_hash.t ->
  rpc_context:Tezos_protocol_environment.rpc_context ->
  base_dir:string ->
  unit tzresult Lwt.t

type base_dir_class =
  | Base_dir_does_not_exist
  | Base_dir_is_mockup
  | Base_dir_is_nonempty
  | Base_dir_is_empty

(** Test whether base directory is a valid target for loading or creating
    a mockup environment. *)
val classify_base_dir : string -> base_dir_class