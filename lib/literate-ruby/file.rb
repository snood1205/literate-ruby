require 'stringio'

module LiterateRuby
  # This class is the file class for literate ruby. It extends Ruby's
  # +File+ class.
  #
  # @attr base [String] the base name of the file
  class File < File
    attr_accessor :base

    # The constructor for +LiterateRuby::File+
    #
    # @param *args the arguments that are passed to super.
    def initialize(*args)
      super(*args)
      @base = File.basename(path, '.*')
    end

    # This method parses a literate ruby file, (which should have the
    # extension +.lrb+), to a normal ruby file (which will have the
    # extension +.rb+).
    #
    # @return [String] the file_path to the normal ruby file.
    def parse
      `touch #{base}.rb`
      file = read
      File.open("#{base}.rb", 'w') do |f|
        file.each_line do |line|
          f.write(line[2..-1]) if line[0..1] == '> '
        end
      end
      "#{base}.rb"
    end

    # This method parses a literate ruby file, (which should have the
    # extension +.lrb+), to a markdown file (which will have the
    # extension +.md+).
    #
    # @return [String] the file_path to the markdown file.
    def to_markdown
      f = File.new("#{base}.md", 'w')
      block = false
      read.each_line { |l| block = to_markdown_helper(l, f, block) }
      "#{base}.md"
    end

    def to_eval_markdown
      f = File.new("#{base}.md", 'w+')
      tmp_f = File.new("#{base}_tmp.rb", 'w+')
      block = false
      read.each_line { |l| block = to_eval_helper(l, f, tmp_f, block) }
      `yes | rm #{base}_tmp.rb`
      "#{base}.md"
    end

    private

    def to_markdown_helper(l, f, block)
      if l[0..1] == '> ' && block then f.write("    #{l[2..-1]}")
      elsif block then block = !f.write("\n#{l}")
      elsif l =~ /^\s+$/ then block = !f.write(l).nil?
      else f.write(l)
      end
      block
    end

    def to_eval_helper(l, f, tmp_f, block)
      if l[0..1] == '> ' && block then tmp_f.write(l[2..-1].to_s)
      elsif block
        block = eval_string(tmp_f, f)
        $stdout = STDOUT
      elsif l =~ /^\s+$/ then block = !f.write(l).nil?
      else f.write(l)
      end
      block
    end

    def eval_string(tmp_f, f)
      s = ''
      IO.popen('ruby', 'w+') do |i|
        i.write(tmp_f.read)
        i.close_write
        s = i.read
      end
      f.puts "    #{s}"
      false
    end
  end
end
