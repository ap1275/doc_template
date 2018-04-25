#!usr/bin/env ruby

require 'json'
require 'base64'

def of(arr, key)
	num = 1
	arr.each do |k|
		num += 1 unless k.key? key
		return num if k.key? key
	end
	return -1
end

def at(arr, key, k2 = nil)
	arr.each do |k|
		if k.key? key
			v = k.values
			if k2 != nil
				v.each do |m|
					return m[k2] if m.key? k2
				end
			else
				return v[0]
			end
		end
	end
	return nil
end

# only media works
def insert(arr, key)
	arr.each do |k|
		if k.key? key
			v = k.values
			v.each do |m|
				data = ""
				begin
					File.open(m[:path], "r") do |f|
						data = f.read
					end
				rescue
					puts "error file #{m[:path]} cannot open"
					exit
				end
				return data
			end
		end
	end
	return nil
end

# json output
def output(title, created, author, tag, media, ref, quota, abstract, body)
	media.each_with_index do |med, i|
		m = {}
		med.each do |key, value|
			value.each do |k, v|
				m[k] = v
				begin
					File.open(v, "r") {|f| m["data"] = Base64.strict_encode64(f.read)} if k == :path
				rescue
					puts "error file #{v} cannot open"
					exit
				end
			end
		end
		media[i] = m
	end
	article = {"title": title, "created": created, "author": author, "tag": tag, "media": media, "reference": ref, "quotation": quota, "abstract": abstract, "body": body}
	str = JSON.generate article
	puts str
end
