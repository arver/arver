class String
  
  # Returns an indented string, all lines of string will be indented with count of chars
  def indent_once
    ("  ") + gsub(/(\n+)/) { $1 + ("  ") }
  end

end