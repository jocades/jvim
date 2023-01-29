const greet = (str: string) => {
  return 'Hello: ' + str
}

const obj = {
  name: 'Jordi',
  age: 10,
  fn: () => 'Hey!',
  self: function () {
    return this.name
  },
}

class Person {
  constructor(public name: string, public age: number) {}

  greet() {
    return 'Hello: ' + this.name
  }

  get ageInDays() {
    return this.age * 365
  }
}

const person = new Person('Jordi', 10)
console.log(person.greet(), person.ageInDays)
