defmodule Factorial do
  def f(0) do 1 end
  def f(n) do n * f(n - 1) end
end
