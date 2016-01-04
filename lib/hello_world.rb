class HelloWorld

  def initialize
    @iteration_number = 0
    
  end

  def hello
    "Hello, World!(#{@iteration_number})"
  end

  def increment
    @iteration_number += 1
  end
end
