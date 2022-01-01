MaxResult = Struct.new(:fitness, :chromosome, :generation)

class GeneticAlgorithm
  def generate(length)
    Array.new(length){rand(0..1)}.join
  end

  def select(population, fitnesses)
    sel = roulette_select(probs(fitnesses))
    population[sel]
  end

  def mutate(chromosome, p)
    chromosome.chars.map{|e| e = 1 - e.to_i if rand < p; e }.join
  end

  def crossover(chromosome1, chromosome2)
    i = rand(1..(chromosome1.length-2))
    new1 = chromosome1[0..i] + chromosome2[(i+1)..-1]
    new2 = chromosome2[0..i] + chromosome1[(i+1)..-1]
    [new1, new2]
  end

  # `length` - size of chromosome (AKA solution)
  #
  # With a probability `p_c`, a crossover occurs between selected two new chromosomes. That means at some random bit
  # along the length of the chromosome, we cut off the rest of the chromosome and switch it with the cut off part of
  # the other one. In other words, say we have 01011010 and 11110110 and we crossover at the 3rd bit.
  # This results in 010 10110 and 111 11010.
  #
  # With a probability `p_m`, a mutation can occur at every bit along each new chromosome; the mutation rate is typically very small.
  def run(fitness, length, p_c, p_m, iterations=100)
    popul_size = 100
    population = Array.new(popul_size) { generate(length) }
    max_result = MaxResult.new(0, '', 0)
    1.upto(iterations) do |i|
      fitnesses = population.map{|e| fitness.call(e) }
      score, index = fitnesses.each_with_index.max
      max_result = MaxResult.new(score, population[index], i) if score > max_result[:fitness]
      puts "generation: #{i} max_fit: #{score}, solution: #{population[index]}"

      new_population = []
      1.upto(popul_size/2) do
        c1 = select(population, fitnesses)
        c2 = select(population, fitnesses)
        c1, c2 = crossover(c1, c2) if rand < p_c
        c1 = mutate(c1, p_m)
        c2 = mutate(c2, p_m)
        new_population += [c1, c2]
      end
      population = new_population
    end
    max_result
  rescue => e
    puts e
    puts e.backtrace
  end

  private

  def roulette_select(probs)
    r = rand
    probs.each_index do |i|
      return i if r < probs[i]
    end
  end

  def probs(fits)
    fit_sum  = fits.inject { |sum, x| sum + x }
    fit_sum = 0.01 if fit_sum == 0
    prob_sum = 0.0
    probs    = []

    fits.each_index do |i|
      f = fits[i]
      probs[i] = prob_sum + (f / fit_sum)
      prob_sum = probs[i]
    end

    probs[probs.size - 1] = 1.0
    probs
  end
end
