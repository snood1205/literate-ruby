module LiterateRuby
  # This class is the file class for literate ruby.
  # It mostly just inherits from Ruby's default File class.
  #
  # The method in this class that is added is `parse`. This method
  # parses a literate ruby file (extension `.lrb`).
  class File < File
    # This method parses a literate ruby file, (which should have the
    # extension `.lrb`), to a normal ruby file (which will have the 
    # extension `.rb`). 
    #
    # @return [String] the file_path to the normal ruby file.
    def parse
      base = File.basename(path, '.*')
      `touch #{base}.rb`
      file = read
      File.open("#{base}.rb", 'w') do |f|
        file.each_line do |line|
          f.write(line[2..-1]) if line[0...2] == '> '
        end
      end
      "#{base}.rb"
    end

    # This method parses a literate ruby file, (which should have the
    # extension `.lrb`), to a markdown file (which will have the 
    # extension `.md`). 
    #
    # @param [Boolean] ghfm if true then it will be written in github
    #   flavored markdown. Otherwise it will be in a more traditional
    #   markdown format
    # @return [String] the file_path to the markdown file.
    def to_markdown(ghfm = false)
      base = File.basename(path, '.*')
      `touch #{base}.md`
      file = read
      File.open("#{base}.md", 'w') do |f|
        code_block = false
        file.each_line do |line|
          if line[0...2] == '> ' && code_block && !ghfm
            f.write("    #{line[2..-1]}")
          elsif line[0...2] == '> ' && code_block
            f.write("#{line[2..-1]}")
          elsif code_block
            code_block = false
            f.write("\n#{line}")
          elsif line =~ /^\s+$/
            code_block = true
            f.write(line)
          else
            f.write(line)
          end
        end
      end
      "#{base}.md"
    end
  end
end
