local pandoc = require 'pandoc'

local toc_inserted = false

-- 在 Pandoc 文档里把 {{TOC}} 段落替换成 Word 目录域
function Pandoc(doc)
  local blocks = {}
  for _, block in ipairs(doc.blocks) do
    if not toc_inserted and block.t == "Para" then
      local is_toc = false
      for _, inline in ipairs(block.c) do
        if inline.t == "Str" and inline.c == "{{TOC}}" then
          is_toc = true
          break
        end
      end
      if is_toc then
        -- 插入 Word 目录域
        table.insert(blocks, pandoc.RawBlock('openxml', '<w:p><w:r><w:fldChar w:fldCharType="begin"/></w:r></w:p>'))
        table.insert(blocks, pandoc.RawBlock('openxml', '<w:p><w:r><w:instrText xml:space="preserve">TOC \\o "1-3" \\h \\z \\u</w:instrText></w:r></w:p>'))
        table.insert(blocks, pandoc.RawBlock('openxml', '<w:p><w:r><w:fldChar w:fldCharType="separate"/></w:r></w:p>'))
        table.insert(blocks, pandoc.RawBlock('openxml', '<w:p><w:r><w:fldChar w:fldCharType="end"/></w:r></w:p>'))
        toc_inserted = true
      else
        table.insert(blocks, block)
      end
    else
      table.insert(blocks, block)
    end
  end
  return pandoc.Pandoc(blocks, doc.meta)
end

-- 在 ## 标题前插入分页符
function Header(elem)
  if elem.level == 2 then
    return {
      pandoc.RawBlock('openxml', '<w:p><w:r><w:br w:type="page"/></w:r></w:p>'),
      elem
    }
  else
    return elem
  end
end
