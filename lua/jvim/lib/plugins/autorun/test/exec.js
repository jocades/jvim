function Person() {
  this.name = 'John'
  this.age = 25
}

Person.prototype.whoami = function () {
  console.log(`My name is ${this.name} and I am ${this.age} years old.`)
}

const person = new Person()

person.whoami()
