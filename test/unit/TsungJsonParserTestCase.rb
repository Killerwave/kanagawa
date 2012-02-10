require "src/TsungJsonParser"
require "test/unit"

class TsungJsonParserTestCase < Test::Unit::TestCase
	def test_status_return_break_when_error_connect_nxdomain_occurred
		json_data = '{"timestamp": 1324898796,  "samples": [
      {"name": "users", "value": 1, "max": 1},
   	  {"name": "users_count", "value": 1, "total": 1},
   	  {"name": "finish_users_count", "value": 0, "total": 0},
   	  {"name": "error_connect_nxdomain", "value": 1, "total": 1}]}'

		assert_when_add_json_status_code_equal(:break,json_data)
	end

	def test_status_return_ok_when_no_error_occurred
		json_data = '{"timestamp": 1324940879,  "samples": [   
			{"name": "users", "value": 0, "max": 1}, 
			{"name": "session", "value": 1, "mean": 228.4990234375,"stdvar": 0,"max":  228.4990234375,"min": 228.4990234375 ,"global_mean": 0 ,"global_count": 0}, 
			{"name": "users_count", "value": 1, "total": 1}, 
			{"name": "finish_users_count", "value": 1, "total": 1}, 
			{"name": "request", "value": 1, "mean": 185.360107421875,"stdvar": 0.0,"max":  185.360107421875,"min": 185.360107421875 ,"global_mean": 0 ,"global_count": 0}, 
			{"name": "page", "value": 1, "mean": 185.360107421875,"stdvar": 0.0,"max":  185.360107421875,"min": 185.360107421875 ,"global_mean": 0 ,"global_count": 0}, 
			{"name": "connect", "value": 1, "mean": 108.09619140625,"stdvar": 0.0,"max":  108.09619140625,"min": 108.09619140625 ,"global_mean": 0 ,"global_count": 0}, 
			{"name": "tr_01_root", "value": 1, "mean": 227.366943359375,"stdvar": 0,"max":  227.366943359375,"min": 227.366943359375 ,"global_mean": 0 ,"global_count": 0}, 
			{"name": "match", "value": 1, "total": 1}, 
			{"name": "http_200", "value": 1, "total": 1}, 
			{"name": "size_rcv", "value": 3666, "total": 3666}, 
			{"name": "size_sent", "value": 54, "total": 54}, 
			{"name": "connected", "value": 0, "max": 0}]}' 

		assert_when_add_json_status_code_equal(:ok,json_data)
	end

	def test_status_return_ok_when_no_data
		assert_when_add_json_status_code_equal(:ok,nil)
	end

	def test_tsung_parser_count_equal_0_when_adding_nil_data
		assert_when_adding_string_tsung_parser_count_equal(0, nil)
	end

	def test_tsung_parser_count_equal_0_when_adding_log_directory_line
		assert_when_adding_string_tsung_parser_count_equal(0, '"Log directory is: /home/tom/.tsung/log/20111227-0007"')
	end

	def test_tsung_parser_count_equal_0_when_adding_first_curly_brace
		assert_when_adding_string_tsung_parser_count_equal(0, '{ ')
	end

	def test_tsung_parser_count_equal_0_when_adding_stats
		assert_when_adding_string_tsung_parser_count_equal(0, '	 "stats": [')
	end

	def test_tsung_parser_count_equal_0_when_adding_empty_line
		assert_when_adding_string_tsung_parser_count_equal(0, ' ')
	end

	def test_tsung_parser_count_equal_1_when_adding_1_good_line
		assert_when_adding_string_tsung_parser_count_equal(1, '		  {"timestamp": 1324940864,  "samples": []},')
	end

	def test_tsung_parser_count_equal_2_when_adding_2_good_lines
		tsung_parser = TsungJsonParser.new()
		json_data_1 = '		  {"timestamp": 1324940864,  "samples": []},'
		json_data_2 = '		  {"timestamp": 1324940874,  "samples": [   {"name": "users", "value": 0, "max": 0}, {"name": "users_count", "value": 0, "total": 0}, {"name": "finish_users_count", "value": 0, "total": 0}]},'

		tsung_parser.add_string(json_data_1)
		tsung_parser.add_string(json_data_2)

		assert_equal(2,tsung_parser.count)
	end

	def test_tsung_parser_count_equal_1_when_adding_a_valid_last_line
		assert_when_adding_string_tsung_parser_count_equal(1, '			 {"timestamp": 1324940879,  "samples": [   {"name": "users", "value": 0, "max": 1}, {"name": "freemem", "hostname": "localhost", "value": 1, "mean": 2932.63671875,"stdvar": 0,"max": 2932.63671875,"min": 2932.63671875 ,"global_mean": 0 ,"global_count": 0}, {"name": "cpu", "hostname": "localhost", "value": 1, "mean": 2.246069378587472,"stdvar": 0,"max": 2.246069378587472,"min": 2.246069378587472 ,"global_mean": 0 ,"global_count": 0}, {"name": "load", "hostname": "localhost", "value": 1, "mean": 0.1015625,"stdvar": 0,"max": 0.1015625,"min": 0.1015625 ,"global_mean": 0 ,"global_count": 0}, {"name": "session", "value": 1, "mean": 228.4990234375,"stdvar": 0,"max":  228.4990234375,"min": 228.4990234375 ,"global_mean": 0 ,"global_count": 0}, {"name": "users_count", "value": 1, "total": 1}, {"name": "finish_users_count", "value": 1, "total": 1}, {"name": "request", "value": 1, "mean": 185.360107421875,"stdvar": 0.0,"max":  185.360107421875,"min": 185.360107421875 ,"global_mean": 0 ,"global_count": 0}, {"name": "page", "value": 1, "mean": 185.360107421875,"stdvar": 0.0,"max":  185.360107421875,"min": 185.360107421875 ,"global_mean": 0 ,"global_count": 0}, {"name": "connect", "value": 1, "mean": 108.09619140625,"stdvar": 0.0,"max":  108.09619140625,"min": 108.09619140625 ,"global_mean": 0 ,"global_count": 0}, {"name": "tr_01_root", "value": 1, "mean": 227.366943359375,"stdvar": 0,"max":  227.366943359375,"min": 227.366943359375 ,"global_mean": 0 ,"global_count": 0}, {"name": "match", "value": 1, "total": 1}, {"name": "http_200", "value": 1, "total": 1}, {"name": "size_rcv", "value": 3666, "total": 3666}, {"name": "size_sent", "value": 54, "total": 54}, {"name": "connected", "value": 0, "max": 0}, {"name": "error_abort", "value": 1, "total": 1}]}]}')
	end

	def test_tsung_parser_count_equal_1_when_adding_truncated_json_with_missing_end_curly_brace
		assert_when_adding_string_tsung_parser_count_equal(1,' {"timestamp": 1325003014,  "samples": [   {"name": "users", "value": 5, "max": 5}, {"name": "freemem", "hostname": "localhost", "value": 1, "mean": 2751.1640625,"stdvar": 0.0,"max": 2751.22265625,"min": 2750.48046875 ,"global_mean": 2750.9388020833335 ,"global_count": 3}, {"name": "cpu", "hostname": "localhost", "value": 1, "mean": 0.5744255744255744,"stdvar": 0.0,"max": 1.6504126031507877,"min": 0.24968789013732834 ,"global_mean": 0.8081920059212137 ,"global_count": 3}, {"name": "load", "hostname": "localhost", "value": 1, "mean": 0.0,"stdvar": 0.0,"max": 0.0,"min": 0.0 ,"global_mean": 0.0 ,"global_count": 3}, {"name": "users_count", "value": 0, "total": 5}, {"name": "finish_users_count", "value": 0, "total": 0}, {"name": "error_connect_nxdomain", "value": 5, "total": 15}')
	end

	def test_tsung_parser_count_equal_1_when_adding_truncated_json_with_missing_end_square_bracket_and_curly_brace
		assert_when_adding_string_tsung_parser_count_equal(1,' {"timestamp": 1325004682,  "samples": [')
	end

  def test_tsung_parser_count_equal_2_when_adding_3_bad_lines_and_2_good_lines_in_one_time
    assert_when_adding_string_tsung_parser_count_equal(2,
    '{ 
			 "stats": [
		 
				  {"timestamp": 1324940864,  "samples": []},
				  {"timestamp": 1324940874,  "samples": [   {"name": "users", "value": 0, "max": 0}, {"name": "users_count", "value": 0, "total": 0}, {"name": "finish_users_count", "value": 0, "total": 0}]},')
	end

  def test_tsung_parser_status_return_break_when_the_mean_load_time_of_last_transactions_is_greater_than_1_second
    json_string = '{
 "stats": [
 {"timestamp": 1328782359,  "samples": []},
 {"timestamp": 1328782369,  "samples": [   {"name": "users", "value": 0, "max": 0}, {"name": "users_count", "value": 0, "total": 0}, {"name": "finish_users_count", "value": 0, "total": 0}]},
 {"timestamp": 1328782379,  "samples": [   {"name": "users", "value": 0, "max": 1}, {"name": "freemem", "hostname": "localhost", "value": 1, "mean": 2846.2890625, "stdvar": 0,  "max": 2846.2890625, "min": 2846.2890625 ,"global_mean": 0 ,             "global_count": 0}, {"name": "cpu", "hostname": "localhost", "value": 1, "mean": 5.529146860145109, "stdvar": 0,  "max": 5.529146860145109,"min": 5.529146860145109 , "global_mean": 0 ,                "global_count": 0}, {"name": "load", "hostname": "localhost", "value": 1, "mean": 0.28125,   "stdvar": 0,  "max": 0.28125,   "min": 0.28125 ,   "global_mean": 0 ,                 "global_count": 0}, {"name": "session", "value": 10, "mean": 87.2705078125,    "stdvar": 30.02569135216157, "max":  151.048095703125,"min": 67.169921875 ,"global_mean": 0 ,                "global_count": 0},  {"name": "users_count", "value": 10, "total": 10}, {"name": "finish_users_count", "value": 10, "total": 10}, {"name": "request", "value": 10, "mean": 84.7352294921875,  "stdvar": 29.476756147925922,"max":  148.87109375,"min": 64.940185546875 ,"global_mean": 0 ,                "global_count": 0},  {"name": "page", "value": 10, "mean": 84.7352294921875,  "stdvar": 29.476756147925922,"max":  148.87109375,"min": 64.940185546875 ,"global_mean": 0 ,                "global_count": 0},  {"name": "connect", "value": 10, "mean": 41.421484375,      "stdvar": 24.37232532943591, "max":  113.0869140625,  "min": 29.0859375 ,"global_mean": 0 ,                 "global_count": 0},  {"name": "tr_01_root", "value": 10, "mean": 85.3384033203125,   "stdvar": 30.031160135253796,"max":  149.121826171875,"min": 65.214111328125 ,"global_mean": 0 ,                "global_count": 0},  {"name": "match", "value": 10, "total": 10}, {"name": "http_200", "value": 10, "total": 10}, {"name": "size_rcv", "value": 36660, "total": 36660},  {"name": "size_sent", "value": 540, "total": 540},  {"name": "connected", "value": 0, "max": 0}]},
 {"timestamp": 1328782389,  "samples": [   {"name": "users", "value": 0, "max": 2}, {"name": "freemem", "hostname": "localhost", "value": 1, "mean": 2861.43359375,"stdvar": 0.0,"max": 2861.43359375,"min": 2846.2890625 ,"global_mean": 2846.2890625 ,  "global_count": 1}, {"name": "cpu", "hostname": "localhost", "value": 1, "mean": 5.75,              "stdvar": 0.0,"max": 5.75,             "min": 5.529146860145109 , "global_mean": 5.529146860145109 ,"global_count": 1}, {"name": "load", "hostname": "localhost", "value": 1, "mean": 0.30859375,"stdvar": 0.0,"max": 0.30859375,"min": 0.28125 ,   "global_mean": 0.28125 ,           "global_count": 1}, {"name": "session", "value": 11, "mean": 77.32319779829545,"stdvar": 13.289474311633885,"max":  151.048095703125,"min": 67.169921875 ,"global_mean": 87.2705078125 ,    "global_count": 10}, {"name": "users_count", "value": 11, "total": 21}, {"name": "finish_users_count", "value": 11, "total": 21}, {"name": "request", "value": 11, "mean": 75.10145152698864, "stdvar": 13.294563530362712,"max":  148.87109375,"min": 64.940185546875 ,"global_mean": 84.7352294921875 , "global_count": 10}, {"name": "page", "value": 11, "mean": 75.10145152698864, "stdvar": 13.294563530362712,"max":  148.87109375,"min": 64.940185546875 ,"global_mean": 84.7352294921875 , "global_count": 10}, {"name": "connect", "value": 11, "mean": 33.85074129971591, "stdvar": 8.65377435332855,  "max":  113.0869140625,  "min": 29.0859375 ,"global_mean": 41.421484375 ,      "global_count": 10}, {"name": "tr_01_root", "value": 11, "mean": 75.3915127840909,   "stdvar": 13.300120375558782,"max":  149.121826171875,"min": 65.214111328125 ,"global_mean": 85.3384033203125 , "global_count": 10}, {"name": "match", "value": 11, "total": 21}, {"name": "http_200", "value": 21, "total": 21}, {"name": "size_rcv", "value": 40326, "total": 76986},  {"name": "size_sent", "value": 594, "total": 1134}, {"name": "connected", "value": 0, "max": 0}]},
 {"timestamp": 1328782399,  "samples": [   {"name": "users", "value": 0, "max": 2}, {"name": "freemem", "hostname": "localhost", "value": 1, "mean": 2845.4765625, "stdvar": 0.0,"max": 2861.43359375,"min": 2845.4765625 ,"global_mean": 2853.861328125 ,"global_count": 2}, {"name": "cpu", "hostname": "localhost", "value": 1, "mean": 3.4207240948813986,"stdvar": 0.0,"max": 5.75,             "min": 3.4207240948813986 ,"global_mean": 5.639573430072554 ,"global_count": 2}, {"name": "load", "hostname": "localhost", "value": 1, "mean": 0.26171875,"stdvar": 0.0,"max": 0.30859375,"min": 0.26171875 ,"global_mean": 0.294921875 ,       "global_count": 2}, {"name": "session", "value": 11, "mean": 72.04962713068181,"stdvar": 8.151361369684894, "max":  151.048095703125,"min": 67.169921875 ,"global_mean": 82.06001209077381 ,"global_count": 21}, {"name": "users_count", "value": 11, "total": 32}, {"name": "finish_users_count", "value": 11, "total": 32}, {"name": "request", "value": 11, "mean": 69.84426047585227, "stdvar": 8.149026322919166, "max":  148.87109375,"min": 64.940185546875 ,"global_mean": 79.68896484375 ,   "global_count": 21}, {"name": "page", "value": 11, "mean": 69.84426047585227, "stdvar": 8.149026322919166, "max":  148.87109375,"min": 64.940185546875 ,"global_mean": 79.68896484375 ,   "global_count": 21}, {"name": "connect", "value": 11, "mean": 30.940540660511363,"stdvar": 1.8365813444937584,"max":  113.0869140625,  "min": 29.0859375 ,"global_mean": 37.45585704985119 , "global_count": 21}, {"name": "tr_01_root", "value": 11, "mean": 70.131103515625,    "stdvar": 8.145273319599392, "max":  149.121826171875,"min": 65.214111328125 ,"global_mean": 80.12812732514881 ,"global_count": 21}, {"name": "match", "value": 11, "total": 32}, {"name": "http_200", "value": 32, "total": 32}, {"name": "size_rcv", "value": 40326, "total": 117312}, {"name": "size_sent", "value": 594, "total": 1728}, {"name": "connected", "value": 0, "max": 0}]},
 {"timestamp": 1328782409,  "samples": [   {"name": "users", "value": 0, "max": 2}, {"name": "freemem", "hostname": "localhost", "value": 1, "mean": 2861.34765625,"stdvar": 0.0,"max": 2861.43359375,"min": 2845.4765625 ,"global_mean": 2851.06640625 , "global_count": 3}, {"name": "cpu", "hostname": "localhost", "value": 1, "mean": 2.35,              "stdvar": 0.0,"max": 5.75,             "min": 2.35 ,              "global_mean": 4.899956985008836 ,"global_count": 3}, {"name": "load", "hostname": "localhost", "value": 1, "mean": 0.21875,   "stdvar": 0.0,"max": 0.30859375,"min": 0.21875 ,   "global_mean": 0.2838541666666667 ,"global_count": 3}, {"name": "session", "value": 8,  "mean": 115.684814453125, "stdvar": 77.69505798150477, "max":  309.12890625,    "min": 67.169921875 ,"global_mean": 78.61894226074219 ,"global_count": 32}, {"name": "users_count", "value": 8,  "total": 40}, {"name": "finish_users_count", "value": 8,  "total": 40}, {"name": "request", "value": 8,  "mean": 113.41543579101563,"stdvar": 77.67002998883223, "max":  306.796875,  "min": 64.940185546875 ,"global_mean": 76.30484771728516 ,"global_count": 32}, {"name": "page", "value": 8,  "mean": 113.41543579101563,"stdvar": 77.67002998883223, "max":  306.796875,  "min": 64.940185546875 ,"global_mean": 76.30484771728516 ,"global_count": 32}, {"name": "connect", "value": 8,  "mean": 50.61212158203125, "stdvar": 34.680065659506276,"max":  117.093994140625,"min": 29.0859375 ,"global_mean": 35.216217041015625 ,"global_count": 32}, {"name": "tr_01_root", "value": 8,  "mean": 1113.74478149414063,"stdvar": 77.70659402976717, "max":  307.218017578125,"min": 65.214111328125 ,"global_mean": 76.691650390625 ,  "global_count": 32}, {"name": "match", "value": 8, "total": 40},  {"name": "http_200", "value": 40, "total": 40}, {"name": "size_rcv", "value": 29559, "total": 146871}, {"name": "size_sent", "value": 432, "total": 2160}, {"name": "connected", "value": 0, "max": 0}]},
 {"timestamp": 1328782419,  "samples": [   {"name": "users", "value": 0, "max": 2}, {"name": "freemem", "hostname": "localhost", "value": 1, "mean": 2861.21484375,"stdvar": 0.0,"max": 2861.43359375,"min": 2845.4765625 ,"global_mean": 2853.63671875 , "global_count": 4}, {"name": "cpu", "hostname": "localhost", "value": 1, "mean": 1.5484515484515484,"stdvar": 0.0,"max": 5.75,             "min": 1.5484515484515484 ,"global_mean": 4.262467738756627 ,"global_count": 4}, {"name": "load", "hostname": "localhost", "value": 1, "mean": 0.19140625,"stdvar": 0.0,"max": 0.30859375,"min": 0.19140625 ,"global_mean": 0.267578125 ,       "global_count": 4}, {"name": "session", "value": 8,  "mean": 77.72036743164063,"stdvar": 16.2682788613853,  "max":  309.12890625,    "min": 67.169921875 ,"global_mean": 86.03211669921875 ,"global_count": 40}, {"name": "users_count", "value": 8,  "total": 48}, {"name": "finish_users_count", "value": 8,  "total": 48}, {"name": "request", "value": 8,  "mean": 75.51071166992188, "stdvar": 16.25711116003825, "max":  306.796875,  "min": 64.940185546875 ,"global_mean": 83.72696533203126 ,"global_count": 40}, {"name": "page", "value": 8,  "mean": 75.51071166992188, "stdvar": 16.25711116003825, "max":  306.796875,  "min": 64.940185546875 ,"global_mean": 83.72696533203126 ,"global_count": 40}, {"name": "connect", "value": 8,  "mean": 32.428497314453125,"stdvar": 3.6319734187567354,"max":  117.093994140625,"min": 29.0859375 ,"global_mean": 38.29539794921875 , "global_count": 40}, {"name": "tr_01_root", "value": 8,  "mean": 1175.78866577148438,"stdvar": 16.261848490395863,"max":  307.218017578125,"min": 65.214111328125 ,"global_mean": 84.10227661132812 ,"global_count": 40}, {"name": "match", "value": 8, "total": 48},  {"name": "http_200", "value": 48, "total": 48}, {"name": "size_rcv", "value": 29328, "total": 176199}, {"name": "size_sent", "value": 432, "total": 2592}, {"name": "connected", "value": 0, "max": 0}, {"name": "error_abort", "value": 1, "total": 1}]}]}'

    assert_when_add_string_status_code_equal (:break, json_string)
  end

end

def assert_when_add_json_status_code_equal return_code, json_data
  tsung_parser = TsungJsonParser.new()

  tsung_parser.add_json(json_data)

  assert_equal(return_code,tsung_parser.status?)
end

def assert_when_adding_string_tsung_parser_count_equal count, string
  tsung_parser = TsungJsonParser.new()

  tsung_parser.add_string(string)
      
  assert_equal(count,tsung_parser.count)
end

def assert_when_add_string_status_code_equal return_code, json_str
  tsung_parser = TsungJsonParser.new()

  tsung_parser.add_string(json_str)

  assert_equal(return_code,tsung_parser.status?)
end
