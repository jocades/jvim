return {
  ---@param opts { name: string, ts: Timestamp }
  header = function(opts)
    return {
      '---',
      'title: ' .. opts.name,
      'date: ' .. string.format(
        '%s | %s | %s',
        opts.ts.date,
        opts.ts.time,
        opts.ts.day
      ),
      '---',
      '',
    }
  end,

  todo = {
    '# TODO:',
    '',
    '- [ ] Task',
  },
}
