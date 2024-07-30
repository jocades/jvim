const $node = document.createElement('div')

$node.innerHTML = `
  <div>
    <h1>Test</h1>
  </div>
`

function css() {}

css`
  h1 {
    color: red;
  }
`

function html() {}

html`
  <div>
    <h1>Test</h1>
  </div>
`
