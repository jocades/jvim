const greet = (str: string) => {
  return "Hello: " + str
}

const obj = {
  name: "Jordi",
  age: 10,
  fn: () => "Hey!",
  self: function () {
    return this.name
  },
}
