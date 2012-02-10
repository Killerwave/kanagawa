require 'json'

class TsungJsonParser
  def initialize
		@datas = Array.new
	end

	# to add one line directly output from JSON tsung this function will cleanup the string before call of add_json
	def add_string(input)
		return 0 if input.nil?
    
    input.each_line do |input_line|

      if input_line.include? "timestamp"
        # remove last ","
        input_line = input_line.sub(/,\s*$/, " ")
        # remove last "]}" they correspond to close of '{"stats": ['
        input_line = input_line.sub(/\}\]\}\]\}\s*$/, "}]}") unless input_line.nil?
        # add ']}' if json is not correctly ended	
        input_line = input_line.sub(/([0-9])\}$/, '\1}]}') unless input_line.nil?
        input_line = input_line.sub(/\[$/, '[]}') unless input_line.nil?
        #puts "Good line : -#{input}-"

        add_json(input_line)
      end
    end
	end

	# to add one data burst in json format
	# one timestamp with samples : {"timestamp": XXXX,  "samples": [ .... ]} 
	def add_json(string)
		@datas << JSON.parse(string) unless string.nil?
	end

	def status?
		return_code = :ok

		return return_code if @datas.nil? 
		return return_code if @datas.count == 0

    # break if error occured
		@datas.last['samples'].each do |sample|
			return return_code if sample.nil?
			if sample['name'] == 'error_connect_nxdomain' && sample['total'] >= 1
				return :break
			end
		end

    # get last 2 transactions mean load time
    set = Hash.new
		@datas.last(2).each do |data|
      return return_code if data.nil?
      data['samples'].each do |sample|
			  return return_code if sample.nil?
        if sample['name'][0,3].eql? "tr_"
          set[sample['name']] = Array.new if set[sample['name']].nil?
          set[sample['name']] << sample['mean']
        end
      end
		end

    # break if all data for same transaction name is greater than 1
    set.each do |name, transaction|
      last_mean = 0
      transaction.each do |mean|
				return :break if last_mean > 1 && mean > 1
        last_mean = mean
      end
    end

		return return_code
	end

	def count
		return @datas.count
	end
end
