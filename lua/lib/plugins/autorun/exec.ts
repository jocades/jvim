function sleep(sec: number) {
  return new Promise((resolve) => setTimeout(resolve, sec * 1000))
}

console.log('Hello')
await sleep(2)
console.log('World')
