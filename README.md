# Template matching without other gems
Katanuki is a Template Matching library that can work without any other gems. It has two funcion. First, Check a original image include a template image. Second, If orignal image include template image, report the location.

# Support Image File Format
Katanuki support only PNG file format.

# Sample Code
```rb
require 'katanuki'
  originalImage = Katanuki::openPNG("original.png")
  templateImage = Katanuki::openPNG("template.png")
  
  isMatch, matchX, matchY = Katanuki::templateMatch(originalImage, templateImage)

  if isMatch
    puts "match logcaion is X:#{matchX} Y:#{matchY}"
  else
    puts "not match then the value of matchX and matchY is 0"
  end
```
