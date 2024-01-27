local present, ls = pcall(require, 'luasnip')

if not present then
  return
end

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function input(args, _, _) return args[1][1] end

local function set_state_name(args_, _, _)
  local state_name = args_[1][1]
  return ', set' .. state_name:sub(1, 1):upper() .. state_name:sub(2)
end

local component_with_state = s({
  trig = 'rfcs',
  name = 'React Functional Component with State',
}, {
  t({
    "'use client'",
    '',
    "import { useState } from 'react'",
    '',
    'interface ',
  }),
  f(input, { 1 }),
  t({ 'Props {' }),
  i(0),
  t({ '}', '', 'export function ' }),
  i(1, 'ComponentName'),
  t({
    '(props: ',
  }),
  f(input, { 1 }),
  t({
    'Props) {',
    '\tconst [',
  }),
  i(2, 'state'),
  f(set_state_name, { 2 }),
  t({
    '] = useState()',
    '',
    '\treturn <div>',
  }),
  f(input, { 1 }),
  t({ '</div>', '}' }),
})

local react_server_component = s({
  trig = 'rsc',
  name = 'React Server Component',
}, {
  t({ 'interface ' }),
  f(input, { 1 }),
  t({ 'Props {' }),
  i(0),
  t({ '}', '', '' }),
  t('export default async function '),
  i(1, 'ComponentName'),
  t({
    '(props: ',
  }),
  f(input, { 1 }),
  t({
    'Props) {',
    '\treturn <div>',
  }),
  f(input, { 1 }),
  t({ '</div>', '}' }),
})

local react_context_provider_with_helper = s({
  trig = 'rcp',
  name = 'React Context Provider with Helper',
}, {
  t({ "import { createContext, useContext } from 'react'", '', '' }),
  t('interface '),
  f(input, { 1 }),
  t({ 'ContextProps {', '\tchildren: React.ReactNode' }),
  i(0),
  t({ '', '}', '', 'function use' }),
  f(input, { 1 }),
  t('Helper(props: '),
  f(input, { 1 }),
  t({
    'ContextProps) {',
    '\treturn {} as const',
    '}',
    '',
  }),

  t('const '),
  i(1, 'Name'),
  t({ 'Context = createContext({} as ReturnType<typeof use' }),
  f(input, { 1 }),
  t({ 'Helper>)', '', 'export const use' }),
  f(input, { 1 }),
  t({ ' = () => useContext(' }),
  f(input, { 1 }),
  t({ 'Context)', '', 'export function ' }),
  f(input, { 1 }),
  t({
    'Provider(props: ',
  }),
  f(input, { 1 }),
  t({
    'ContextProps) {',
    '\tconst value = use',
  }),
  f(input, { 1 }),
  t({
    'Helper(props)',
    '',
    '\treturn (',
    '\t\t<',
  }),
  f(input, { 1 }),
  t({
    'Context.Provider value={value}>{props.children}</',
  }),
  f(input, { 1 }),
  t({ 'Context.Provider>', '\t)', '}' }),
})

ls.add_snippets('typescriptreact', {
  component_with_state,
  react_server_component,
  react_context_provider_with_helper,
})
