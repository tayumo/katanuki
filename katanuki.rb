require 'zlib'

module Katanuki
  def self.openPNG(png_file_path)
    width = 0
    height = 0
    bit_depth = 0
    color_type = 0
    compress_method = 0
    filter_method = 0
    interlace = 0
    zlib_data = String.new

    File.open(png_file_path, 'rb') { |png|
      signature = png.read(8)

      if signature != "\x89\x50\x4e\x47\x0d\x0a\x1a\x0a".b
        puts("This is not a PNG file: #{png_file_path}\n")
        return nil
      end

      while length_raw = png.read(4)
        length = length_raw.unpack('L>')[0] #big endian uint32_t
        type   = png.read(4)
        data   = png.read(length)
        crc    = png.read(4).unpack('L>')[0]

        case type
        when 'IHDR'
          width, height, bit_depth, color_type, compress_method, filter_method, interlace = data.unpack('L>L>CCCCC')
        when 'IDAT'
          zlib_data += data
        end
      end
    }

    if bit_depth != 8
      puts "ERROR:bit_depth != 8 is not support now!"
      return nil
    elsif color_type != 2 and color_type != 6
      puts "ERROR:color_type != 4 or color_type != 6 is not support now!"
      return nil
    elsif filter_method != 0
      puts "ERROR:filter_method != 0 is not support now!"
      return nil
    elsif compress_method != 0
      puts "ERROR:compress_method != 0 is not support now!"
      return nil
    end

    if interlace != 0
      puts "ERROR:interlace != 0 is not support now!"
      return nil
    end

    pixel_size = 3
    pixel_size = 4 if color_type == 6

    unzlib_data = Zlib::Inflate.inflate(zlib_data)

    i=0
    line_size = width * pixel_size + 1

    unzlib_data_bytes = unzlib_data.bytes
    filter_type = 0

    height.times { |y|
      filter_type = unzlib_data_bytes[y * line_size]
      case filter_type
      #when 0 #none
      when 1 #sub
        x = pixel_size + 1
        while x<line_size
          index = y*line_size + x
          unzlib_data_bytes[index] = (unzlib_data_bytes[index-pixel_size] + unzlib_data_bytes[index]) & 0xff
          x += 1
        end
      when 2 #up
        x = 1
        while x<line_size
          if 0<y
            index = y*line_size + x
            unzlib_data_bytes[index] = (unzlib_data_bytes[index-line_size] + unzlib_data_bytes[index]) & 0xff
          end
          x += 1
        end
      when 3 #avg
        index = y*line_size+1

        if y < 1
          x = pixel_size + 1
          while x<line_size
            index = y*line_size + x
            unzlib_data_bytes[index] = ((unzlib_data_bytes[index-pixel_size])/2 + unzlib_data_bytes[index]) & 0xff
            x += 1
          end
        else
          unzlib_data_bytes[index  ] = (unzlib_data_bytes[index  -line_size]/2 + unzlib_data_bytes[index  ]) & 0xff
          unzlib_data_bytes[index+1] = (unzlib_data_bytes[index+1-line_size]/2 + unzlib_data_bytes[index+1]) & 0xff
          unzlib_data_bytes[index+2] = (unzlib_data_bytes[index+2-line_size]/2 + unzlib_data_bytes[index+2]) & 0xff
          if pixel_size == 4
            unzlib_data_bytes[index+3] = (unzlib_data_bytes[index+3-line_size]/2 + unzlib_data_bytes[index+3]) & 0xff
          end
          x = pixel_size + 1
          while x<line_size
            index = y*line_size + x
            unzlib_data_bytes[index] = ((unzlib_data_bytes[index-line_size]+unzlib_data_bytes[index-pixel_size])/2 + unzlib_data_bytes[index]) & 0xff
            x += 1
          end
        end
      when 4 #paeth
        if y<1
          x = pixel_size
          while x<line_size
            index = y*line_size+x
            #paethPredictor
            up     = 0
            left   = unzlib_data_bytes[index-pixel_size]
            upleft = unzlib_data_bytes[index-line_size-pixel_size]
            pleft   = (up - upleft).abs
            pup     = (left - upleft).abs
            pupleft = (left + up - upleft*2).abs

            if pleft <= pup and pleft <= pupleft
              unzlib_data_bytes[index] = (left + unzlib_data_bytes[index]) & 0xff
            elsif pup <= pupleft
              unzlib_data_bytes[index] = (up + unzlib_data_bytes[index]) & 0xff
            else
              unzlib_data_bytes[index] = (upleft + unzlib_data_bytes[index]) & 0xff
            end
            x += 1
          end
        else
          x = 1
          while x<pixel_size
            index = y*line_size+x
            #paethPredictor
            up     = unzlib_data_bytes[index-line_size]
            left,upleft = 0,0
            p = left + up - upleft
            pleft   = (up - upleft).abs
            pup     = (left - upleft).abs
            pupleft = (left + up - upleft - upleft).abs
            if pleft <= pup and pleft <= pupleft
              unzlib_data_bytes[index] = (left + unzlib_data_bytes[index]) & 0xff
            elsif pup <= pupleft
              unzlib_data_bytes[index] = (up + unzlib_data_bytes[index]) & 0xff
            else
              unzlib_data_bytes[index] = (upleft + unzlib_data_bytes[index]) & 0xff
            end
            x += 1
          end

          x = pixel_size
          while x<line_size
            index = y*line_size+x
            #paethPredictor
            up     = unzlib_data_bytes[index-line_size]
            left   = unzlib_data_bytes[index-pixel_size]
            upleft = unzlib_data_bytes[index-line_size-pixel_size]
            pleft   = (up - upleft).abs
            pup     = (left - upleft).abs
            pupleft = (left + up - upleft*2).abs

            if pleft <= pup and pleft <= pupleft
              unzlib_data_bytes[index] = (left + unzlib_data_bytes[index]) & 0xff
            elsif pup <= pupleft
              unzlib_data_bytes[index] = (up + unzlib_data_bytes[index]) & 0xff
            else
              unzlib_data_bytes[index] = (upleft + unzlib_data_bytes[index]) & 0xff
            end
            x += 1
          end
        end
      end
    }

    size = width * height
    bitmap_data_red = Array.new(size,0)
    bitmap_data_green = Array.new(size,0)
    bitmap_data_blue = Array.new(size,0)
    height.times{ |y|
      width.times{ |x|
        index = y*width + x
        target_index = (y*pixel_size*width+y) + (pixel_size*x) + 1

        bitmap_data_red[index]   = unzlib_data_bytes[target_index  ]
        bitmap_data_green[index] = unzlib_data_bytes[target_index+1]
        bitmap_data_blue[index]  = unzlib_data_bytes[target_index+2]
      }
    }
    return Bitmap.new(width, height, bitmap_data_red, bitmap_data_green, bitmap_data_blue)
  end

  def self.templateMatch(original_bitmap, template_bitmap)
    matched = false
    matched_x = 0
    matched_y = 0

    if original_bitmap.width < 0 or original_bitmap.width < template_bitmap.width
      #puts "Error: template bitmap width is larger then original bitmap"
      return matched, matched_x, matched_y
    end
    if original_bitmap.height < 0 or original_bitmap.height < template_bitmap.height
      #puts "Error: template bitmap height is larger then original bitmap"
      return matched, matched_x, matched_y
    end

    scan_max_width = original_bitmap.width - template_bitmap.width + 1
    scan_max_height = original_bitmap.height - template_bitmap.height + 1

    finish_index = template_bitmap.width * template_bitmap.height
    scan_max_height.times { |scan_point_y|
      scan_max_width.times { |scan_point_x|
        target_index = (original_bitmap.width * scan_point_y) + scan_point_x

        template_index = 0
        original_index = target_index
        original_offset = 0
        epsilon = 5
        while true
          break if epsilon < (original_bitmap.data_red[original_index] - template_bitmap.data_red[template_index]).abs
          break if epsilon < (original_bitmap.data_green[original_index] - template_bitmap.data_green[template_index]).abs
          break if epsilon < (original_bitmap.data_blue[original_index] - template_bitmap.data_blue[template_index]).abs

          template_index += 1
          original_index += 1

          if template_index % template_bitmap.width == 0
            original_index += (original_bitmap.width - template_bitmap.width)
          end

          if template_index == finish_index
            matched = true
            matched_x = scan_point_x
            matched_y = scan_point_y
            break
          end
        end

        break if matched
      }
      break if matched
    }

    return matched, matched_x, matched_y
  end

  class Bitmap
    attr_accessor :width
    attr_accessor :height
    attr_accessor :data_red
    attr_accessor :data_green
    attr_accessor :data_blue
    def initialize(width, height, data_red, data_green, data_blue)
      @width = width
      @height = height
      @data_red = data_red
      @data_green = data_green
      @data_blue = data_blue
    end
  
    def dump
      puts "start BitMap Dump"
      puts "  width=#{@width}"
      puts "  height=#{@height}"
  
      @height.times { |i|
        @width.times { |j|
          index = (@width * i) + j
          print sprintf("%4d ",@data_red[index])
          print sprintf("%4d ",@data_green[index])
          print sprintf("%4d ",@data_blue[index])
          print "| "
        }
        puts ""
      }
    end
  end
end

