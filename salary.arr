use context starter2024
fun salary_calculate(salary :: Number, distance :: Number) -> Number:
  ask:
    | salary < 2001 then:
      ask:
        | distance < 5 then: salary - 80
        | (10 > distance) and (distance > 5) then: salary - 120
        | distance > 10 then: salary - 200
      end
    | salary > 2000 then:
      ask: 
        | distance < 5 then: salary - 110
        | (10 > distance) and (distance > 5) then: salary - 160
        | distance > 10 then: salary - 240
      end
  end
where:
  salary_calculate(3000, 3) is 2890
    salary_calculate(3000, 6) is 2840
    salary_calculate(3000, 11) is 2760
    salary_calculate(1000, 3) is 920
    salary_calculate(1000, 6) is 880
    salary_calculate(1000, 11) is 800
end