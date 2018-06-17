module FactoryBotHelpers
  def random_tag
    joiner = %w(. _).sample
    prefix = ['', 'v'].sample
    prefix + (0..2).map { rand(10) }.join(joiner)
  end
end
