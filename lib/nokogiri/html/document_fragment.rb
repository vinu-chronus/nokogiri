module Nokogiri
  module HTML
    class DocumentFragment < Nokogiri::XML::DocumentFragment
      ####
      # Create a Nokogiri::XML::DocumentFragment from +tags+, using +encoding+
      def self.parse tags, encoding = 'UTF-8'
        doc = HTML::Document.new

        if tags.respond_to?(:encoding)
          doc.encoding = tags.encoding.name
        else
          doc.encoding = encoding
        end

        new(doc, tags)
      end

      def initialize document, tags = nil, ctx = nil
        return self unless tags

        children = if ctx
                     ctx.parse("<div>#{tags.strip}</div>").first.children
                   else
                     ###
                     # This is a horrible hack, but I don't care
                     if tags.strip =~ /^<body/i
                       path = "/html/body"
                     else
                       path = "/html/body/node()"
                     end

                     HTML::Document.parse(
                       "<html><body>#{tags.strip}</body></html>",
                       nil,
                       document.encoding
                     ).xpath(path)
                   end
        children.each { |child| child.parent = self }
      end
    end
  end
end
