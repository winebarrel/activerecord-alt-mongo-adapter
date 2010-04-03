#
# DO NOT MODIFY!!!!
# This file is automatically generated by racc 1.4.5
# from racc grammer file "sqlparser.y".
#

require 'racc/parser'



require 'strscan'

module ActiveMongo


class SQLParser < Racc::Parser

module_eval <<'..end sqlparser.y modeval..id1a149d81a3', 'sqlparser.y', 215

KEYWORDS = %w(
  AND
  AS
  ASC
  BETWEEN
  BY
  COUNT
  DELETE
  DESC
  DISTINCT
  EXISTS
  FROM
  IN
  INSERT
  INTO
  LIMIT
  MOD
  NOT
  OFFSET
  ORDER
  REGEXP
  SELECT
  SET
  UPDATE
  VALUES
  WHERE
)

KEYWORD_REGEXP = Regexp.compile("(?:#{KEYWORDS.join '|'})\\b", Regexp::IGNORECASE)

def initialize(obj)
  src = obj.is_a?(IO) ? obj.read : obj.to_s
  @ss = StringScanner.new(src)
end

def scan
  piece = nil

  until @ss.eos?
    if (tok = @ss.scan /\s+/)
      # nothing to do
    elsif (tok = @ss.scan /(?:<>|!=|>=|<=|>|<|=)/)
      yield tok, tok
    elsif (tok = @ss.scan KEYWORD_REGEXP)
      yield tok.upcase.to_sym, tok
    elsif (tok = @ss.scan /NULL\b/i)
      yield :NULL, nil
    elsif (tok = @ss.scan /'(?:[^']|'')*'/) #'
      yield :STRING, tok.slice(1...-1).gsub(/''/, "'")
    elsif (tok = @ss.scan /-?(?:0|[1-9]\d*)(?:\.\d+)/)
      yield :NUMBER, tok.to_f
    elsif (tok = @ss.scan /-?(?:0|[1-9]\d*)/)
      yield :NUMBER, tok.to_i
    elsif (tok = @ss.scan /[,\(\)\*]/)
      yield tok, tok
    elsif (tok = @ss.scan /(?:[a-z_]\w+\.|[a-z]\.)*ID\b/i)
      yield :ID, tok
    elsif (tok = @ss.scan /(?:[a-z_]\w+\.|[a-z]\.)*(?:[a-z_]\w+|[a-z])/i)
      yield :IDENTIFIER, tok
    else
      raise Racc::ParseError, ('parse error on value "%s"' % @ss.rest.inspect)
    end
  end

  yield false, '$'
end
private :scan

def parse
  yyparse self, :scan
end

..end sqlparser.y modeval..id1a149d81a3

##### racc 1.4.5 generates ###

racc_reduce_table = [
 0, 0, :racc_error,
 1, 44, :_reduce_none,
 1, 44, :_reduce_none,
 1, 44, :_reduce_none,
 1, 44, :_reduce_none,
 10, 45, :_reduce_5,
 8, 46, :_reduce_6,
 6, 46, :_reduce_7,
 8, 46, :_reduce_8,
 4, 57, :_reduce_9,
 6, 57, :_reduce_10,
 1, 58, :_reduce_none,
 1, 58, :_reduce_none,
 1, 52, :_reduce_13,
 1, 52, :_reduce_none,
 0, 53, :_reduce_15,
 2, 53, :_reduce_16,
 2, 53, :_reduce_17,
 1, 59, :_reduce_none,
 3, 59, :_reduce_19,
 3, 61, :_reduce_20,
 5, 61, :_reduce_21,
 1, 60, :_reduce_22,
 3, 60, :_reduce_23,
 1, 63, :_reduce_none,
 3, 63, :_reduce_25,
 3, 64, :_reduce_26,
 4, 64, :_reduce_27,
 5, 64, :_reduce_28,
 1, 64, :_reduce_none,
 1, 64, :_reduce_none,
 5, 66, :_reduce_31,
 6, 67, :_reduce_32,
 0, 54, :_reduce_33,
 4, 54, :_reduce_34,
 0, 68, :_reduce_35,
 1, 68, :_reduce_none,
 0, 55, :_reduce_37,
 2, 55, :_reduce_38,
 0, 56, :_reduce_39,
 2, 56, :_reduce_40,
 5, 47, :_reduce_41,
 1, 70, :_reduce_none,
 3, 70, :_reduce_43,
 3, 71, :_reduce_44,
 4, 48, :_reduce_45,
 1, 49, :_reduce_none,
 1, 50, :_reduce_47,
 3, 50, :_reduce_48,
 1, 62, :_reduce_none,
 1, 62, :_reduce_none,
 1, 62, :_reduce_none,
 1, 51, :_reduce_52,
 3, 51, :_reduce_53,
 1, 65, :_reduce_54,
 1, 65, :_reduce_55,
 1, 65, :_reduce_56,
 1, 65, :_reduce_57,
 1, 65, :_reduce_58,
 1, 65, :_reduce_59,
 1, 65, :_reduce_60,
 1, 65, :_reduce_61,
 1, 65, :_reduce_62,
 1, 65, :_reduce_63,
 1, 65, :_reduce_64,
 1, 69, :_reduce_65,
 1, 69, :_reduce_66 ]

racc_reduce_n = 67

racc_shift_n = 137

racc_action_table = [
   102,   125,     3,    35,    69,    70,    98,     9,   131,   132,
   115,    62,    78,    81,    27,    84,    85,    45,    88,    65,
   128,   134,    63,   124,   136,     5,    67,    68,     8,    86,
    74,    75,    76,    77,    79,    80,    82,    83,    71,    51,
    71,    71,   124,   124,    27,    41,   124,    13,    50,    50,
    78,    81,    56,    56,    56,    56,    20,    21,    35,    15,
    35,    26,    13,    13,    13,    13,    13,    86,    74,    75,
    76,    77,    79,    80,    82,    83,    13,    65,    13,    65,
    88,    65,    13,    65,    67,    68,    67,    68,    67,    68,
    67,    68,    65,    90,    65,    90,    65,    35,    65,    67,
    68,    67,    68,    67,    68,    67,    68,    65,    94,    65,
    95,    28,    97,    24,    67,    68,    67,    68,    47,    99,
   100,    13,    13,    22,    13,   106,   107,   107,    13,    14,
    40,   114,    13,    13,    13,    13,   119,   121,   121,    13,
    13,    35,    13,    11,    31,   133,    10,    30,   111 ]

racc_action_check = [
    87,   113,     0,    32,    50,    50,    72,     0,   118,   118,
   101,    42,    53,    53,    18,    53,    53,    32,    72,    87,
   116,   123,    44,   113,   126,     0,    87,    87,     0,    53,
    53,    53,    53,    53,    53,    53,    53,    53,    51,    35,
    71,    88,   116,   123,    44,    30,   126,    45,    51,    35,
    89,    89,    51,    35,    71,    88,     9,     9,    39,     9,
    37,    16,    30,    51,    35,    71,    88,    89,    89,    89,
    89,    89,    89,    89,    89,    89,     9,    97,    14,   111,
    54,   105,    56,   102,    97,    97,   111,   111,   105,   105,
   102,   102,   114,    59,   115,    60,    69,    61,    47,   114,
   114,   115,   115,    69,    69,    47,    47,   124,    62,    85,
    63,    19,    70,    12,   124,   124,    85,    85,    33,    73,
    84,    31,    11,    10,    20,    90,    91,    92,    94,     8,
    29,   100,    40,    28,    27,   106,   107,   108,   109,    26,
     5,    25,    24,     3,    23,   121,     1,    21,    95 ]

racc_action_pointer = [
     0,   146,   nil,   140,   nil,   111,   nil,   nil,   121,    47,
   123,    93,    87,   nil,    49,   nil,    53,   nil,   -13,   103,
    95,   143,   nil,   140,   113,   128,   110,   105,   104,   122,
    33,    92,   -10,   103,   nil,    35,   nil,    47,   nil,    45,
   103,   nil,     6,   nil,    17,    18,   nil,    75,   nil,   nil,
   -11,    34,   nil,    -3,    63,   nil,    53,   nil,   nil,    73,
    75,    84,    97,   104,   nil,   nil,   nil,   nil,   nil,    73,
   108,    36,     1,   114,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   104,    86,   nil,    -4,    37,    35,
   104,   104,   105,   nil,    99,   144,   nil,    54,   nil,   nil,
   127,    -7,    60,   nil,   nil,    58,   106,   113,   113,   114,
   nil,    56,   nil,    -4,    69,    71,    15,   nil,   -33,   nil,
   nil,   122,   nil,    16,    84,   nil,    19,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil ]

racc_action_default = [
   -67,   -67,    -1,   -67,    -2,   -67,    -3,    -4,   -67,   -67,
   -67,   -67,   -67,   -46,   -67,   -13,   -67,   -47,   -14,   -67,
   -67,   -67,   137,   -67,   -67,   -15,   -67,   -67,   -67,   -67,
   -67,   -67,   -15,   -67,   -42,   -67,   -45,   -15,   -48,   -15,
   -67,   -11,   -67,   -12,   -67,   -67,   -41,   -67,   -29,   -30,
   -67,   -67,   -16,   -67,   -17,   -18,   -67,   -22,   -24,   -33,
   -33,   -15,    -9,   -67,   -43,   -50,   -44,   -49,   -51,   -67,
   -67,   -67,   -67,   -67,   -56,   -57,   -58,   -59,   -64,   -60,
   -61,   -54,   -62,   -63,   -67,   -67,   -55,   -67,   -67,   -67,
   -67,   -37,   -37,    -7,   -67,   -67,   -20,   -67,   -25,   -19,
   -67,   -67,   -67,   -26,   -23,   -67,   -67,   -67,   -39,   -39,
   -10,   -67,   -52,   -67,   -67,   -67,   -67,   -27,   -35,   -38,
    -8,   -67,    -6,   -67,   -67,   -21,   -67,   -31,   -28,   -34,
   -36,   -65,   -66,   -40,    -5,   -53,   -32 ]

racc_goto_table = [
    12,    87,    55,    19,    17,    66,    23,    34,    18,    25,
   108,   109,    91,    92,     7,    29,    16,    36,    73,    33,
    42,    37,    38,    39,    46,    43,    17,    96,    64,    59,
    44,    60,    52,   113,    54,    61,     6,   105,   116,     4,
    33,   120,   122,   101,   104,   103,     2,   123,   129,   130,
   126,    89,    32,    93,     1,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   117,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   127,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   135,   nil,   nil,   nil,   nil,   nil,   nil,   110,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   118 ]

racc_goto_check = [
     6,    22,    18,     9,     6,    19,     6,    28,     7,     6,
    12,    12,    11,    11,     5,     6,    14,    10,    18,     6,
    15,     6,     6,     6,    10,     6,     6,    19,    28,    10,
     7,    10,    16,     8,    17,     6,     4,    22,     8,     3,
     6,    13,    13,    19,    20,    19,     2,     8,    25,    26,
     8,     6,    27,    10,     1,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    19,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,    19,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,    19,   nil,   nil,   nil,   nil,   nil,   nil,     6,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     6 ]

racc_goto_pointer = [
   nil,    54,    46,    39,    36,    14,    -5,    -1,   -64,    -6,
    -8,   -47,   -81,   -67,     7,   -10,    -3,    -1,   -33,   -42,
   -44,   nil,   -52,   nil,   nil,   -70,   -69,    28,   -17 ]

racc_goto_default = [
   nil,   nil,   nil,   nil,   nil,   nil,    53,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    72,   nil,   112,
    57,    58,   nil,    48,    49,   nil,   nil,   nil,   nil ]

racc_token_table = {
 false => 0,
 Object.new => 1,
 :INSERT => 2,
 :INTO => 3,
 "(" => 4,
 ")" => 5,
 :VALUES => 6,
 :SELECT => 7,
 :FROM => 8,
 :DISTINCT => 9,
 :COUNT => 10,
 :AS => 11,
 "*" => 12,
 :WHERE => 13,
 :ID => 14,
 "=" => 15,
 :IN => 16,
 :AND => 17,
 :NOT => 18,
 :BETWEEN => 19,
 :ORDER => 20,
 :BY => 21,
 :LIMIT => 22,
 :NUMBER => 23,
 :OFFSET => 24,
 :UPDATE => 25,
 :SET => 26,
 "," => 27,
 :DELETE => 28,
 :IDENTIFIER => 29,
 :STRING => 30,
 :NULL => 31,
 :REGEXP => 32,
 :MOD => 33,
 :EXISTS => 34,
 "<>" => 35,
 "!=" => 36,
 ">=" => 37,
 "<=" => 38,
 ">" => 39,
 "<" => 40,
 :ASC => 41,
 :DESC => 42 }

racc_use_result_var = false

racc_nt_base = 43

Racc_arg = [
 racc_action_table,
 racc_action_check,
 racc_action_default,
 racc_action_pointer,
 racc_goto_table,
 racc_goto_check,
 racc_goto_default,
 racc_goto_pointer,
 racc_nt_base,
 racc_reduce_table,
 racc_token_table,
 racc_shift_n,
 racc_reduce_n,
 racc_use_result_var ]

Racc_token_to_s_table = [
'$end',
'error',
'INSERT',
'INTO',
'"("',
'")"',
'VALUES',
'SELECT',
'FROM',
'DISTINCT',
'COUNT',
'AS',
'"*"',
'WHERE',
'ID',
'"="',
'IN',
'AND',
'NOT',
'BETWEEN',
'ORDER',
'BY',
'LIMIT',
'NUMBER',
'OFFSET',
'UPDATE',
'SET',
'","',
'DELETE',
'IDENTIFIER',
'STRING',
'NULL',
'REGEXP',
'MOD',
'EXISTS',
'"<>"',
'"!="',
'">="',
'"<="',
'">"',
'"<"',
'ASC',
'DESC',
'$start',
'sql',
'create_statement',
'read_statemant',
'update_statemant',
'delete_statemant',
'id',
'id_list',
'value_list',
'select_list',
'where_clause',
'order_by_clause',
'limit_clause',
'offset_clause',
'count_clause',
'count_arg',
'id_search_condition',
'search_condition',
'id_predicate',
'value',
'boolean_primary',
'predicate',
'op',
'between_predicate',
'not_in_predicate',
'ordering_spec',
'order_spec',
'set_clause_list',
'set_clause']

Racc_debug_parser = false

##### racc system variables end #####

 # reduce 0 omitted

 # reduce 1 omitted

 # reduce 2 omitted

 # reduce 3 omitted

 # reduce 4 omitted

module_eval <<'.,.,', 'sqlparser.y', 12
  def _reduce_5( val, _values)
                            {:command => :insert, :table => val[2], :column_list => val[4], :value_list => val[8]}
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 17
  def _reduce_6( val, _values)
                            {:command => :select, :table => val[3], :select_list => val[1], :condition => val[4], :order => val[5], :limit => val[6], :offset => val[7]}
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 21
  def _reduce_7( val, _values)
                            {:command => :select, :table => val[4], :select_list => val[2], :distinct => val[2], :condition => val[5]}
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 25
  def _reduce_8( val, _values)
                            {:command => :select, :table => val[3], :count => val[1], :condition => val[4], :order => val[5], :limit => val[6], :offset => val[7]}
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 30
  def _reduce_9( val, _values)
                            "count_all"
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 34
  def _reduce_10( val, _values)
                            val[5]
  end
.,.,

 # reduce 11 omitted

 # reduce 12 omitted

module_eval <<'.,.,', 'sqlparser.y', 42
  def _reduce_13( val, _values)
                            []
  end
.,.,

 # reduce 14 omitted

module_eval <<'.,.,', 'sqlparser.y', 48
  def _reduce_15( val, _values)
                            []
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 52
  def _reduce_16( val, _values)
                            val[1]
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 56
  def _reduce_17( val, _values)
                            val[1]
  end
.,.,

 # reduce 18 omitted

module_eval <<'.,.,', 'sqlparser.y', 62
  def _reduce_19( val, _values)
                            val[1]
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 67
  def _reduce_20( val, _values)
                            val[2]
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 71
  def _reduce_21( val, _values)
                            val[3]
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 76
  def _reduce_22( val, _values)
                            [val[0]].flatten
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 80
  def _reduce_23( val, _values)
                            (val[0] << val[2]).flatten
  end
.,.,

 # reduce 24 omitted

module_eval <<'.,.,', 'sqlparser.y', 86
  def _reduce_25( val, _values)
                            val[1]
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 91
  def _reduce_26( val, _values)
                            {:name => val[0], :op => val[1], :expr => val[2]}
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 95
  def _reduce_27( val, _values)
                            {:name => val[1], :op => val[2], :expr => val[3], :not => true}
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 99
  def _reduce_28( val, _values)
                            {:name => val[0], :op => val[1], :expr => val[3]}
  end
.,.,

 # reduce 29 omitted

 # reduce 30 omitted

module_eval <<'.,.,', 'sqlparser.y', 106
  def _reduce_31( val, _values)
                            {:name => val[0], :op => '$bt', :expr => [val[2], val[4]]}
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 111
  def _reduce_32( val, _values)
                            {:name => val[0], :op => '$nin', :expr => val[4]}
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 116
  def _reduce_33( val, _values)
                            nil
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 120
  def _reduce_34( val, _values)
                            {:name => val[2], :type => val[3]}
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 125
  def _reduce_35( val, _values)
                            :asc
  end
.,.,

 # reduce 36 omitted

module_eval <<'.,.,', 'sqlparser.y', 131
  def _reduce_37( val, _values)
                            nil
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 135
  def _reduce_38( val, _values)
                            val[1]
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 140
  def _reduce_39( val, _values)
                            nil
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 144
  def _reduce_40( val, _values)
                            val[1]
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 149
  def _reduce_41( val, _values)
                            {:command => :update, :table => val[1], :set_clause_list => val[3], :condition => val[4]}
  end
.,.,

 # reduce 42 omitted

module_eval <<'.,.,', 'sqlparser.y', 155
  def _reduce_43( val, _values)
                            val[0].merge val[2]
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 160
  def _reduce_44( val, _values)
                          {val[0] => val[2]}
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 165
  def _reduce_45( val, _values)
                            {:command => :delete, :table => val[2], :condition => val[3]}
  end
.,.,

 # reduce 46 omitted

module_eval <<'.,.,', 'sqlparser.y', 172
  def _reduce_47( val, _values)
                            [val[0]]
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 176
  def _reduce_48( val, _values)
                            val[0] << val[2]
  end
.,.,

 # reduce 49 omitted

 # reduce 50 omitted

 # reduce 51 omitted

module_eval <<'.,.,', 'sqlparser.y', 185
  def _reduce_52( val, _values)
                            [val[0]]
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 189
  def _reduce_53( val, _values)
                            val[0] << val[2]
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 190
  def _reduce_54( val, _values)
 '$in'
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 191
  def _reduce_55( val, _values)
 '$regexp'
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 192
  def _reduce_56( val, _values)
 '$mod'
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 193
  def _reduce_57( val, _values)
 '$exists'
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 194
  def _reduce_58( val, _values)
 '$ne'
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 195
  def _reduce_59( val, _values)
 '$ne'
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 196
  def _reduce_60( val, _values)
 '$gte'
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 197
  def _reduce_61( val, _values)
 '$lte'
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 198
  def _reduce_62( val, _values)
 '$gt'
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 199
  def _reduce_63( val, _values)
 '$lt'
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 200
  def _reduce_64( val, _values)
 '$eq'
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 202
  def _reduce_65( val, _values)
 :asc
  end
.,.,

module_eval <<'.,.,', 'sqlparser.y', 203
  def _reduce_66( val, _values)
 :desc
  end
.,.,

 def _reduce_none( val, _values)
  val[0]
 end

end   # class SQLParser


end # module ActiveMongo
