require 'zlib'

def chunk(type, data)
  [data.bytesize, type, data, Zlib.crc32(type + data)].pack("NA4A*N")
end

def create(file_name, width, height, raw_data, with_alpha=false)
  png_file = open(file_name,"wb")

  #signature
  png_file.write("\x89\x50\x4e\x47\x0d\x0a\x1a\x0a".b)

  #START IHDR
  if with_alpha
    depth = 8
    color_type = 6
  else
    depth = 8
    color_type = 2
  end
  compress_method = 0
  filter_method = 0
  interlace = 0

  png_file.write(chunk("IHDR", [width, height, depth, color_type, compress_method, filter_method, interlace].pack("NNCCCCC")))
  #END IHDR

  #START IDAT
  img_data = raw_data.pack("C*")
  png_file.write(chunk("IDAT", Zlib::Deflate.deflate(img_data)))
  #END IDAT
  #START IEND
  png_file.write(chunk("IEND", ""))
  #START IEND
  png_file.close
end

def create_paeth_filter(file_name, width, height, raw_data, with_alpha=false)
  png_file = open(file_name,"wb")

  #signature
  png_file.write("\x89\x50\x4e\x47\x0d\x0a\x1a\x0a".b)

  #START IHDR
  if with_alpha
    depth = 8
    color_type = 6
  else
    depth = 8
    color_type = 2
  end
  compress_method = 0
  filter_method = 0
  interlace = 0

  png_file.write(chunk("IHDR", [width, height, depth, color_type, compress_method, filter_method, interlace].pack("NNCCCCC")))
  #END IHDR

  #apply filter
  pixel_size = 3
  paeth_filtered_data = []
  height.times{ |y|
    index = (width*pixel_size+1)*y
    paeth_filtered_data.push(4)
    width.times{ |x|
      3.times{ |i|
        v = raw_data[index+x*3+1+i]
        left = 0
        if x!=0
          left = raw_data[index+(x-1)*3+1+i]
        end
        up = 0
        if y!= 0
          up = raw_data[index-(width*pixel_size+1)+x*3+1+i]
        end
        upleft = 0
        if x!=0 and y!= 0
          upleft = raw_data[index-(width*pixel_size+1)+(x-1)*3+1+i]
        end
        pleft   = (up - upleft).abs
        pup     = (left - upleft).abs
        pupleft = (left + up - upleft*2).abs
        if pleft <= pup and pleft <= pupleft
          paeth_filtered_data.push((v-left).abs)
        elsif pup <= pupleft
          paeth_filtered_data.push((up - v).abs)
        else
          paeth_filtered_data.push((upleft - v).abs)
        end
      }
    }
  }

  #START IDAT
  img_data = paeth_filtered_data.pack("C*")
  png_file.write(chunk("IDAT", Zlib::Deflate.deflate(img_data)))
  #END IDAT
  #START IEND
  png_file.write(chunk("IEND", ""))
  #START IEND
  png_file.close
end

#create base.png
width, height = 5, 5
raw_data = [
  0,     0,  0,  0,     0, 50,  0,     0,100,  0,     0,150,  0,     0,200,  0,
  0,    50,  0,  0,    50, 50,  0,    50,100,  0,    50,150,  0,    50,200,  0,
  0,   100,  0,  0,   100, 50,  0,   100,100,  0,   100,150,  0,   100,200,  0,
  0,   150,  0,  0,   150, 50,  0,   150,100,  0,   150,150,  0,   150,200,  0,
  0,   200,  0,  0,   200, 50,  0,   200,100,  0,   200,150,  0,   200,200,  0,
]
create("testImages/base.png", width, height, raw_data)

#create base_sub_filter.png
width, height = 5, 5
raw_data = [
  1,     0,  0,  0,     0, 50,  0,     0, 50,  0,     0, 50,  0,     0, 50,  0,
  1,    50,  0,  0,     0, 50,  0,     0, 50,  0,     0, 50,  0,     0, 50,  0,
  1,   100,  0,  0,     0, 50,  0,     0, 50,  0,     0, 50,  0,     0, 50,  0,
  1,   150,  0,  0,     0, 50,  0,     0, 50,  0,     0, 50,  0,     0, 50,  0,
  1,   200,  0,  0,     0, 50,  0,     0, 50,  0,     0, 50,  0,     0, 50,  0,
]
create("testImages/base_sub_filter.png", width, height, raw_data)

#create base_up_filter.png
width, height = 5, 5
raw_data = [
  2,     0,  0,  0,     0, 50,  0,     0,100,  0,     0,150,  0,     0,200,  0,
  2,    50,  0,  0,    50,  0,  0,    50,  0,  0,    50,  0,  0,    50,  0,  0,
  2,    50,  0,  0,    50,  0,  0,    50,  0,  0,    50,  0,  0,    50,  0,  0,
  2,    50,  0,  0,    50,  0,  0,    50,  0,  0,    50,  0,  0,    50,  0,  0,
  2,    50,  0,  0,    50,  0,  0,    50,  0,  0,    50,  0,  0,    50,  0,  0,
]
create("testImages/base_up_filter.png", width, height, raw_data)

#create base_avg_filter.png
width, height = 5, 5
raw_data = [
  3,     0,  0,  0,     0, 50,  0,     0, 75,  0,     0,100,  0,     0,125,  0,
  3,    50,  0,  0,    25, 25,  0,    25, 25,  0,    25, 25,  0,    25, 25,  0,
  3,    75,  0,  0,    25, 25,  0,    25, 25,  0,    25, 25,  0,    25, 25,  0,
  3,   100,  0,  0,    25, 25,  0,    25, 25,  0,    25, 25,  0,    25, 25,  0,
  3,   125,  0,  0,    25, 25,  0,    25, 25,  0,    25, 25,  0,    25, 25,  0,
]
create("testImages/base_avg_filter.png", width, height, raw_data)

#create base_paeth_filter.png
width, height = 5, 5
raw_data = [
  0,     0,  0,  0,     0, 50,  0,     0,100,  0,     0,150,  0,     0,200,  0,
  0,    50,  0,  0,    50, 50,  0,    50,100,  0,    50,150,  0,    50,200,  0,
  0,   100,  0,  0,   100, 50,  0,   100,100,  0,   100,150,  0,   100,200,  0,
  0,   150,  0,  0,   150, 50,  0,   150,100,  0,   150,150,  0,   150,200,  0,
  0,   200,  0,  0,   200, 50,  0,   200,100,  0,   200,150,  0,   200,200,  0,
]
create_paeth_filter("testImages/base_paeth_filter.png", width, height, raw_data)

#create match_top_left.png
width, height = 3, 3
raw_data = [
  0,     0,  0,  0,     0, 50,  0,    0,100,  0,
  0,    50,  0,  0,    50, 50,  0,   50,100,  0,
  0,   100,  0,  0,   100, 50,  0,  100,100,  0,
]
create("testImages/match_top_left.png", width, height, raw_data)

#create match_top_right.png
width, height = 3, 3
raw_data = [
  0,     0,100,  0,     0,150,  0,     0,200,  0,
  0,    50,100,  0,    50,150,  0,    50,200,  0,
  0,   100,100,  0,   100,150,  0,   100,200,  0,
]
create("testImages/match_top_right.png", width, height, raw_data)

#create match_bottom_left.png
width, height = 3, 3
raw_data = [
  0,   100,  0,  0,   100, 50,  0,   100,100,  0,
  0,   150,  0,  0,   150, 50,  0,   150,100,  0,
  0,   200,  0,  0,   200, 50,  0,   200,100,  0,
]
create("testImages/match_bottom_left.png", width, height, raw_data)

#create match_bottom_left.png
width, height = 3, 3
raw_data = [
  0,   100,100,  0,   100,150,  0,   100,200,  0,
  0,   150,100,  0,   150,150,  0,   150,200,  0,
  0,   200,100,  0,   200,150,  0,   200,200,  0,
]
create("testImages/match_bottom_right.png", width, height, raw_data)

#create match_center.png
width, height = 3, 3
raw_data = [
  0,    50, 50,  0,    50,100,  0,    50,150,  0,
  0,   100, 50,  0,   100,100,  0,   100,150,  0,
  0,   150, 50,  0,   150,100,  0,   150,150,  0,
]
create("testImages/match_center.png", width, height, raw_data)

#create no_match.png
width, height = 3, 3
raw_data = [
  0,   250,250,250,   250,250,250,   250,250,250,
  0,   250,250,250,   250,250,250,   250,250,250,
  0,   250,250,250,   250,250,250,   250,250,250,
]
create("testImages/no_match.png", width, height, raw_data)

#create base_with_alpha.png
width, height = 5, 5
raw_data = [
  0,     0,  0,  0,255,     0, 50,  0,255,    0,100,  0,255,     0,150,  0,255,     0,200,  0,255,
  0,    50,  0,  0,255,    50, 50,  0,255,   50,100,  0,255,    50,150,  0,255,    50,200,  0,255,
  0,   100,  0,  0,255,   100, 50,  0,255,  100,100,  0,255,   100,150,  0,255,   100,200,  0,255,
  0,   150,  0,  0,255,   150, 50,  0,255,  150,100,  0,255,   150,150,  0,255,   150,200,  0,255,
  0,   200,  0,  0,255,   200, 50,  0,255,  200,100,  0,255,   200,150,  0,255,   200,200,  0,255,
]
create("testImages/base_with_alpha.png", width, height, raw_data, true)

#create match_top_left_with_alpha.png
width, height = 3, 3
raw_data = [
  0,     0,  0,  0,255,     0, 50,  0,255,     0,100,  0,255,
  0,    50,  0,  0,255,    50, 50,  0,255,    50,100,  0,255,
  0,   100,  0,  0,255,   100, 50,  0,255,   100,100,  0,255,
]
create("testImages/match_top_left_with_alpha.png", width, height, raw_data, true)

#create match_top_right_with_alpha.png
width, height = 3, 3
raw_data = [
  0,     0,100,  0,255,     0,150,  0,255,     0,200,  0,255,
  0,    50,100,  0,255,    50,150,  0,255,    50,200,  0,255,
  0,   100,100,  0,255,   100,150,  0,255,   100,200,  0,255,
]
create("testImages/match_top_right_with_alpha.png", width, height, raw_data, true)

#create match_bottom_left_with_alpha.png
width, height = 3, 3
raw_data = [
  0,   100,  0,  0,255,   100, 50,  0,255,   100,100,  0,255,
  0,   150,  0,  0,255,   150, 50,  0,255,   150,100,  0,255,
  0,   200,  0,  0,255,   200, 50,  0,255,   200,100,  0,255,
]
create("testImages/match_bottom_left_with_alpha.png", width, height, raw_data, true)

#create match_bottom_left_with_alpha.png
width, height = 3, 3
raw_data = [
  0,   100,100,  0,255,   100,150,  0,255,   100,200,  0,255,
  0,   150,100,  0,255,   150,150,  0,255,   150,200,  0,255,
  0,   200,100,  0,255,   200,150,  0,255,   200,200,  0,255,
]
create("testImages/match_bottom_right_with_alpha.png", width, height, raw_data, true)

#create match_center_with_alpha.png
width, height = 3, 3
raw_data = [
  0,    50, 50,  0,255,    50,100,  0,255,    50,150,  0,255,
  0,   100, 50,  0,255,   100,100,  0,255,   100,150,  0,255,
  0,   150, 50,  0,255,   150,100,  0,255,   150,150,  0,255,
]
create("testImages/match_center_with_alpha.png", width, height, raw_data, true)

#create no_match_with_alpha.png
width, height = 3, 3
raw_data = [
  0,   250,250,250,255,   250,250,250,255,   250,250,250,255,
  0,   250,250,250,255,   250,250,250,255,   250,250,250,255,
  0,   250,250,250,255,   250,250,250,255,   250,250,250,255,
]
create("testImages/no_match_with_alpha.png", width, height, raw_data, true)

#create base8x4.png
width, height = 8, 4
raw_data = [
  0,     0,  0,  0,     0, 30,  0,     0, 60,  0,     0, 90,  0,     0,120,  0,     0,150,  0,     0,180,  0,     0,210,  0,
  0,    30,  0,  0,    30, 30,  0,    30, 60,  0,    30, 90,  0,    30,120,  0,    30,150,  0,    30,180,  0,    30,210,  0,
  0,    60,  0,  0,    60, 30,  0,    60, 60,  0,    60, 90,  0,    60,120,  0,    60,150,  0,    60,180,  0,    60,210,  0,
  0,    90,  0,  0,    90, 30,  0,    90, 60,  0,    90, 90,  0,    90,120,  0,    90,150,  0,    90,180,  0,    90,210,  0,
]
create("testImages/base8x4.png", width, height, raw_data)

#create match_bottom_right4x1.png
width, height = 4, 1
raw_data = [
  0,    90,120,  0,    90,150,  0,    90,180,  0,    90,210,  0,
]
create("testImages/match_bottom_right4x1.png", width, height, raw_data)

#create base4x8.png
width, height = 4, 8
raw_data = [
  0,     0,  0,  0,     0, 30,  0,     0, 60,  0,     0, 90,  0,
  0,    30,  0,  0,    30, 30,  0,    30, 60,  0,    30, 90,  0,
  0,    60,  0,  0,    60, 30,  0,    60, 60,  0,    60, 90,  0,
  0,    90,  0,  0,    90, 30,  0,    90, 60,  0,    90, 90,  0,
  0,   120,  0,  0,   120, 30,  0,   120, 60,  0,   120, 90,  0,
  0,   150,  0,  0,   150, 30,  0,   150, 60,  0,   150, 90,  0,
  0,   180,  0,  0,   180, 30,  0,   180, 60,  0,   180, 90,  0,
  0,   210,  0,  0,   210, 30,  0,   210, 60,  0,   210, 90,  0,
]
create("testImages/base4x8.png", width, height, raw_data)

#create match_bottom_right1x4.png
width, height = 1, 4
raw_data = [
  0,   120, 90,  0,
  0,   150, 90,  0,
  0,   180, 90,  0,
  0,   210, 90,  0,
]
create("testImages/match_bottom_right1x4.png", width, height, raw_data)
