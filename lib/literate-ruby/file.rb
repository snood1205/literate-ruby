module LiterateRuby
  class File < File
    def parse
      base = File.basename(path, '.*')
      `touch #{File.basename(path, '.*')}.rb`
      file = read
      File.open("#{base}.rb", 'w') do |f|
        file.each_line do |line|
          f.write(line[2..-1]) if line[0...2] == '> '
        end
      end
      "#{base}.rb"
    end
  end
end
