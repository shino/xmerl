%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 2004-2011. All Rights Reserved.
%%
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%%
%% %CopyrightEnd%
%%
%% Contributor(s):
%%    <michael.remond@IDEALX.com>: suggested #xmlDocument{}
%%
%%----------------------------------------------------------------------
%% #0.    BASIC INFORMATION
%%----------------------------------------------------------------------
%% File:       xmerl.hrl
%% Author       : Ulf Wiger <ulf.wiger@ericsson.com>
%% Date         : 00-09-22
%% Description  : Record and macro definitions for xmerl
%%----------------------------------------------------------------------



%% records generated by the scanner
%% --------------------------------

%% XML declaration
-record(xmlDecl,{
          vsn,        % string() XML version
          encoding,   % string() Character encoding
          standalone, % (yes | no)
          attributes  % [#xmlAttribute()] Other attributes than above
         }).

%% Attribute
-record(xmlAttribute,{
          name,            % atom()
          expanded_name=[],% atom() | {string(),atom()}
          nsinfo = [],     % {Prefix, Local} | []
          namespace = [],  % inherits the element's namespace
          parents = [],    % [{atom(),integer()}]
          pos,             % integer()
          language = [],   % inherits the element's language
          value,           % IOlist() | atom() | integer()
          normalized       % atom() one of (true | false)
         }).

%% namespace record
-record(xmlNamespace,{
          default = [],
          nodes = []
         }).

%% namespace node - i.e. a {Prefix, URI} pair
-record(xmlNsNode,{
          parents = [], % [{atom(),integer()}]
          pos,          % integer()
          prefix,       % string()
          uri = []      % [] | atom()
         }).

%% XML Element
%% content = [#xmlElement()|#xmlText()|#xmlPI()|#xmlComment()|#xmlDecl()]
-record(xmlElement,{
          name,                 % atom()
          tag,                  % atom()
          expanded_name = [],   % string() | {URI,Local} | {"xmlns",Local}
          nsinfo = [],          % {Prefix, Local} | []
          namespace=#xmlNamespace{},
          parents = [],         % [{atom(),integer()}]
          pos,                  % integer()
          attributes = [],      % [#xmlAttribute()]
          content = [],
          language = "",        % string()
          xmlbase="",           % string() XML Base path, for relative URI:s
          elementdef=undeclared % atom(), one of [undeclared | prolog | external | element]
         }).

%% plain text
%% IOlist = [char() | binary () | IOlist]
-record(xmlText,{
          parents = [], % [{atom(),integer()}]
          pos,          % integer()
          language = [],% inherits the element's language
          value,        % IOlist()
          type = text   % atom() one of (text|cdata)
         }).

%% plain text
-record(xmlComment,{
          parents = [],  % [{atom(),integer()}]
          pos,           % integer()
          language = [], % inherits the element's language
          value          % IOlist()
         }).

%% processing instruction
-record(xmlPI,{
          name,         % atom()
          parents = [], % [{atom(),integer()}]
          pos,          % integer()
          value         % IOlist()
         }).

-record(xmlDocument,{
          content
         }).


%% XPATH (xmerl_xpath, xmerl_pred_funcs) records

-record(xmlContext, {
                     axis_type = forward,
                     context_node,
                     context_position = 1,
                     nodeset = [],
                     bindings = [],
                     functions = [],
                     namespace = [],
                     whole_document
                    }).

-record(xmlNode, {
                  type = element,
                  node,
                  parents = [],
                  pos = 1
                 }).

-record(xmlObj, {
                 type,
                 value
                 }).

-record(xmerl_fun_states, {event,
                           hook,
                           rules,
                           fetch,
                           cont}).


%% scanner state record
-record(xmerl_scanner,{
          encoding=undefined, % undefined | string() Character set used, default is UTF-8
          standalone = no,
%         prolog =continue,
          environment = prolog,    % atom(), (prolog | element)
          declarations = [],       % [{Name, Attrs}]
          doctype_name,
          doctype_DTD = internal, % internal | DTDId
          comments = true,
          document = false,
          default_attrs = false,
          rules,
          keep_rules = false,   % delete (ets) tab if false
          namespace_conformant = false, % true | false
          xmlbase,          % string() Current Base path, for relative URI:s
          xmlbase_cache,    % string() Cached Base path
          fetch_path=[], % [string()] List with additional, user
                         % defined, paths
          filename=file_name_unknown,
          validation = off, %% off (default) | dtd | schema (true, false are obsolete)
          schemaLocation = [],
          space = preserve,
          event_fun,
          hook_fun,
          acc_fun,
          fetch_fun,
          close_fun,
          continuation_fun,
          rules_read_fun,
          rules_write_fun,
          rules_delete_fun,
          user_state,
          fun_states = #xmerl_fun_states{},
          entity_references=[],
          text_decl=false,
          quiet=false,   % bool() Set to true will print no error messages
          col = 1,
          line = 1,
          common_data = []
         }).




%% scanner events

%% event : start | end
-record(xmerl_event, {
                      event,
                      line,
                      col,
                      pos,
                      data
                     }).



%% useful scanner macros
%% ---------------------

-define(space, 32).
-define(cr,    13).
-define(lf,    10).
-define(tab,   9).
%% whitespace consists of 'space', 'carriage return', 'line feed' or 'tab'
-define(whitespace(H), H==?space ; H==?cr ; H==?lf ; H==?tab).

%% non-caharacters according to Unicode: 16#ffff and 16#fffe
-define(non_character(H1,H2), H1==16#ff,H2==16#fe;H1==16#ff,H2==16#ff).

-define(non_ascii(H), list(H),hd(H)>=128;integer(H),H>=128).

-define(strip1,  {_, T1,  S1}  = strip(T,  S)).
-define(strip2,  {_, T2,  S2}  = strip(T1, S1)).
-define(strip3,  {_, T3,  S3}  = strip(T2, S2)).
-define(strip4,  {_, T4,  S4}  = strip(T3, S3)).
-define(strip5,  {_, T5,  S5}  = strip(T4, S4)).
-define(strip6,  {_, T6,  S6}  = strip(T5, S5)).
-define(strip7,  {_, T7,  S7}  = strip(T6, S6)).
-define(strip8,  {_, T8,  S8}  = strip(T7, S7)).
-define(strip9,  {_, T9,  S9}  = strip(T8, S8)).
-define(strip10, {_, T10, S10} = strip(T9, S9)).

-define(condstrip1,  {_, T1,  S1}  = condstrip(T, S, false)).
-define(condstrip2,  {_, T2,  S2}  = condstrip(T1,S1,false)).
-define(condstrip3,  {_, T3,  S3}  = condstrip(T2,S2,false)).
-define(condstrip4,  {_, T4,  S4}  = condstrip(T3,S3,false)).

-define(bump_col(N),
        ?dbg("bump_col(~p), US = ~p~n", [N, S0#xmerl_scanner.user_state]),
        S = S0#xmerl_scanner{col = S0#xmerl_scanner.col + N}).
