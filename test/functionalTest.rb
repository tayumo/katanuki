require "minitest/autorun"
require '../katanuki'

class TestMeme < Minitest::Test
  def setup
    @base_bitmap = Katanuki::openPNG("testImages/base.png")
    @match_bottom_left_bitmap = Katanuki::openPNG("testImages/match_bottom_left.png")
    @match_bottom_right_bitmap = Katanuki::openPNG("testImages/match_bottom_right.png")
    @match_top_left_bitmap = Katanuki::openPNG("testImages/match_top_left.png")
    @match_top_right_bitmap = Katanuki::openPNG("testImages/match_top_right.png")
    @match_center_bitmap = Katanuki::openPNG("testImages/match_center.png")
    @base8x4_bitmap = Katanuki::openPNG("testImages/base8x4.png")
    @match_bottom_right4x1_bitmap = Katanuki::openPNG("testImages/match_bottom_right4x1.png")
    @base4x8_bitmap = Katanuki::openPNG("testImages/base4x8.png")
    @match_bottom_right1x4_bitmap = Katanuki::openPNG("testImages/match_bottom_right1x4.png")
    @no_match_bitmap = Katanuki::openPNG("testImages/no_match.png")

    #include alpha
    @base_with_alpha_bitmap = Katanuki::openPNG("testImages/base_with_alpha.png")
    @match_bottom_left_with_alpha_bitmap = Katanuki::openPNG("testImages/match_bottom_left_with_alpha.png")
    @match_bottom_right_with_alpha_bitmap = Katanuki::openPNG("testImages/match_bottom_right_with_alpha.png")
    @match_top_left_with_alpha_bitmap = Katanuki::openPNG("testImages/match_top_left_with_alpha.png")
    @match_top_right_with_alpha_bitmap = Katanuki::openPNG("testImages/match_top_right_with_alpha.png")
    @match_center_with_alpha_bitmap = Katanuki::openPNG("testImages/match_center_with_alpha.png")
    @no_match_with_alpha_bitmap = Katanuki::openPNG("testImages/no_match_with_alpha.png")

    #filterd_png_files
    @sub_filtered_base_bitmap = Katanuki::openPNG("testImages/base_sub_filter.png")
    @up_filtered_base_bitmap = Katanuki::openPNG("testImages/base_up_filter.png")
    @avg_filtered_base_bitmap = Katanuki::openPNG("testImages/base_avg_filter.png")
    @paeth_filtered_base_bitmap = Katanuki::openPNG("testImages/base_paeth_filter.png")
    @filtered_base_bitmap = Katanuki::openPNG("testImages/filtered_base.png")
    @filtered_template_bitmap = Katanuki::openPNG("testImages/filtered_template.png")
  end

  def test_convert_base_png
    expect_data_red = [
        0,   0,   0,   0,   0,
       50,  50,  50,  50,  50,
      100, 100, 100, 100, 100,
      150, 150, 150, 150, 150,
      200, 200, 200, 200, 200]
    expect_data_green = [
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200]
    expect_data_blue = [
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0]
    expect_width=5
    expect_height=5

    assert_equal @base_bitmap.data_red,   expect_data_red
    assert_equal @base_bitmap.data_green, expect_data_green
    assert_equal @base_bitmap.data_blue,  expect_data_blue
    assert_equal @base_bitmap.width,      expect_width
    assert_equal @base_bitmap.height,     expect_height
  end

  def test_convert_match_bottom_left_bitmap_png
    expect_data_red = [
      100, 100, 100,
      150, 150, 150,
      200, 200, 200]
    expect_data_green = [
        0,  50, 100,
        0,  50, 100,
        0,  50, 100]
    expect_data_blue = [
        0,   0,   0,
        0,   0,   0,
        0,   0,   0]
    expect_width=3
    expect_height=3

    assert_equal @match_bottom_left_bitmap.data_red,   expect_data_red
    assert_equal @match_bottom_left_bitmap.data_green, expect_data_green
    assert_equal @match_bottom_left_bitmap.data_blue,  expect_data_blue
    assert_equal @match_bottom_left_bitmap.width,      expect_width
    assert_equal @match_bottom_left_bitmap.height,     expect_height
  end

  def test_convert_match_bottom_right_bitmap_png
    expect_data_red = [
      100, 100, 100,
      150, 150, 150,
      200, 200, 200]
    expect_data_green = [
      100, 150, 200,
      100, 150, 200,
      100, 150, 200]
    expect_data_blue = [
        0,   0,   0,
        0,   0,   0,
        0,   0,   0]
    expect_width=3
    expect_height=3

    assert_equal @match_bottom_right_bitmap.data_red,   expect_data_red
    assert_equal @match_bottom_right_bitmap.data_green, expect_data_green
    assert_equal @match_bottom_right_bitmap.data_blue,  expect_data_blue
    assert_equal @match_bottom_right_bitmap.width,      expect_width
    assert_equal @match_bottom_right_bitmap.height,     expect_height
  end

  def test_convert_match_top_left_bitmap_png
    expect_data_red = [
        0,   0,   0,
       50,  50,  50,
      100, 100, 100]
    expect_data_green = [
        0,  50, 100,
        0,  50, 100,
        0,  50, 100]
    expect_data_blue = [
        0,   0,   0,
        0,   0,   0,
        0,   0,   0]
    expect_width=3
    expect_height=3

    assert_equal @match_top_left_bitmap.data_red,   expect_data_red
    assert_equal @match_top_left_bitmap.data_green, expect_data_green
    assert_equal @match_top_left_bitmap.data_blue,  expect_data_blue
    assert_equal @match_top_left_bitmap.width,      expect_width
    assert_equal @match_top_left_bitmap.height,     expect_height
  end

  def test_convert_match_top_right_bitmap_png
    expect_data_red = [
        0,   0,   0,
       50,  50,  50,
      100, 100, 100]
    expect_data_green = [
      100, 150, 200,
      100, 150, 200,
      100, 150, 200]
    expect_data_blue = [
        0,   0,   0,
        0,   0,   0,
        0,   0,   0]
    expect_width=3
    expect_height=3

    assert_equal @match_top_right_bitmap.data_red,   expect_data_red
    assert_equal @match_top_right_bitmap.data_green, expect_data_green
    assert_equal @match_top_right_bitmap.data_blue,  expect_data_blue
    assert_equal @match_top_right_bitmap.width,      expect_width
    assert_equal @match_top_right_bitmap.height,     expect_height
  end

  def test_convert_match_center_bitmap_png
    expect_data_red = [
       50,  50,  50,
      100, 100, 100,
      150, 150, 150]
    expect_data_green = [
       50, 100, 150,
       50, 100, 150,
       50, 100, 150]
    expect_data_blue = [
        0,   0,   0,
        0,   0,   0,
        0,   0,   0]
    expect_width=3
    expect_height=3

    assert_equal @match_center_bitmap.data_red,   expect_data_red
    assert_equal @match_center_bitmap.data_green, expect_data_green
    assert_equal @match_center_bitmap.data_blue,  expect_data_blue
    assert_equal @match_center_bitmap.width,      expect_width
    assert_equal @match_center_bitmap.height,     expect_height
  end

  def test_convert_base8x4_bitmap_png
    expect_data_red = [
        0,   0,   0,   0,   0,   0,   0,   0,
       30,  30,  30,  30,  30,  30,  30,  30,
       60,  60,  60,  60,  60,  60,  60,  60,
       90,  90,  90,  90,  90,  90,  90,  90]
    expect_data_green = [
        0,  30,  60,  90, 120, 150, 180, 210,
        0,  30,  60,  90, 120, 150, 180, 210,
        0,  30,  60,  90, 120, 150, 180, 210,
        0,  30,  60,  90, 120, 150, 180, 210]
    expect_data_blue = [
        0,   0,   0,   0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,   0,   0,   0]
    expect_width=8
    expect_height=4

    assert_equal @base8x4_bitmap.data_red,   expect_data_red
    assert_equal @base8x4_bitmap.data_green, expect_data_green
    assert_equal @base8x4_bitmap.data_blue,  expect_data_blue
    assert_equal @base8x4_bitmap.width,      expect_width
    assert_equal @base8x4_bitmap.height,     expect_height
  end

  def test_convert_match_bottom_right4x1_bitmap_png
    expect_data_red = [
       90,  90,  90,  90]
    expect_data_green = [
      120, 150, 180, 210]
    expect_data_blue = [
        0,   0,   0,   0]
    expect_width=4
    expect_height=1

    assert_equal @match_bottom_right4x1_bitmap.data_red,   expect_data_red
    assert_equal @match_bottom_right4x1_bitmap.data_green, expect_data_green
    assert_equal @match_bottom_right4x1_bitmap.data_blue,  expect_data_blue
    assert_equal @match_bottom_right4x1_bitmap.width,      expect_width
    assert_equal @match_bottom_right4x1_bitmap.height,     expect_height
  end

  def test_convert_base4x8_bitmap_png
    expect_data_red = [
        0,   0,   0,   0,
       30,  30,  30,  30,
       60,  60,  60,  60,
       90,  90,  90,  90,
      120, 120, 120, 120,
      150, 150, 150, 150,
      180, 180, 180, 180,
      210, 210, 210, 210]
    expect_data_green = [
        0,  30,  60,  90,
        0,  30,  60,  90,
        0,  30,  60,  90,
        0,  30,  60,  90,
        0,  30,  60,  90,
        0,  30,  60,  90,
        0,  30,  60,  90,
        0,  30,  60,  90]
    expect_data_blue = [
        0,   0,   0,   0,
        0,   0,   0,   0,
        0,   0,   0,   0,
        0,   0,   0,   0,
        0,   0,   0,   0,
        0,   0,   0,   0,
        0,   0,   0,   0,
        0,   0,   0,   0]
    expect_width=4
    expect_height=8

    assert_equal @base4x8_bitmap.data_red,   expect_data_red
    assert_equal @base4x8_bitmap.data_green, expect_data_green
    assert_equal @base4x8_bitmap.data_blue,  expect_data_blue
    assert_equal @base4x8_bitmap.width,      expect_width
    assert_equal @base4x8_bitmap.height,     expect_height
  end

  def test_convert_match_bottom_right1x4_bitmap_png
    expect_data_red = [
      120,
      150,
      180,
      210]
    expect_data_green = [
       90,
       90,
       90,
       90]
    expect_data_blue = [
        0,
        0,
        0,
        0]
    expect_width=1
    expect_height=4

    assert_equal @match_bottom_right1x4_bitmap.data_red,   expect_data_red
    assert_equal @match_bottom_right1x4_bitmap.data_green, expect_data_green
    assert_equal @match_bottom_right1x4_bitmap.data_blue,  expect_data_blue
    assert_equal @match_bottom_right1x4_bitmap.width,      expect_width
    assert_equal @match_bottom_right1x4_bitmap.height,     expect_height
  end

  def test_convert_no_match_bitmap_png
    expect_data_red = [
      250, 250, 250,
      250, 250, 250,
      250, 250, 250]
    expect_data_green = [
      250, 250, 250,
      250, 250, 250,
      250, 250, 250]
    expect_data_blue = [
      250, 250, 250,
      250, 250, 250,
      250, 250, 250]
    expect_width=3
    expect_height=3

    assert_equal @no_match_bitmap.data_red,   expect_data_red
    assert_equal @no_match_bitmap.data_green, expect_data_green
    assert_equal @no_match_bitmap.data_blue,  expect_data_blue
    assert_equal @no_match_bitmap.width,      expect_width
    assert_equal @no_match_bitmap.height,     expect_height
  end

  def test_base_with_alpha_bitmap
    expect_data_red = [
        0,   0,   0,   0,   0,
       50,  50,  50,  50,  50,
      100, 100, 100, 100, 100,
      150, 150, 150, 150, 150,
      200, 200, 200, 200, 200]
    expect_data_green = [
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200]
    expect_data_blue = [
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0]
    expect_width=5
    expect_height=5

    assert_equal @base_with_alpha_bitmap.data_red,   expect_data_red
    assert_equal @base_with_alpha_bitmap.data_green, expect_data_green
    assert_equal @base_with_alpha_bitmap.data_blue,  expect_data_blue
    assert_equal @base_with_alpha_bitmap.width,      expect_width
    assert_equal @base_with_alpha_bitmap.height,     expect_height
  end

  def test_match_bottom_left_with_alpha_bitmap
    expect_data_red = [
      100, 100, 100,
      150, 150, 150,
      200, 200, 200]
    expect_data_green = [
        0,  50, 100,
        0,  50, 100,
        0,  50, 100]
    expect_data_blue = [
        0,   0,   0,
        0,   0,   0,
        0,   0,   0]
    expect_width=3
    expect_height=3

    assert_equal @match_bottom_left_with_alpha_bitmap.data_red,   expect_data_red
    assert_equal @match_bottom_left_with_alpha_bitmap.data_green, expect_data_green
    assert_equal @match_bottom_left_with_alpha_bitmap.data_blue,  expect_data_blue
    assert_equal @match_bottom_left_with_alpha_bitmap.width,      expect_width
    assert_equal @match_bottom_left_with_alpha_bitmap.height,     expect_height
  end

  def test_match_bottom_right_with_alpha_bitmap
    expect_data_red = [
      100, 100, 100,
      150, 150, 150,
      200, 200, 200]
    expect_data_green = [
      100, 150, 200,
      100, 150, 200,
      100, 150, 200]
    expect_data_blue = [
        0,   0,   0,
        0,   0,   0,
        0,   0,   0]
    expect_width=3
    expect_height=3

    assert_equal @match_bottom_right_with_alpha_bitmap.data_red,   expect_data_red
    assert_equal @match_bottom_right_with_alpha_bitmap.data_green, expect_data_green
    assert_equal @match_bottom_right_with_alpha_bitmap.data_blue,  expect_data_blue
    assert_equal @match_bottom_right_with_alpha_bitmap.width,      expect_width
    assert_equal @match_bottom_right_with_alpha_bitmap.height,     expect_height
  end

  def test_match_top_left_with_alpha_bitmap
    expect_data_red = [
        0,   0,   0,
       50,  50,  50,
      100, 100, 100]
    expect_data_green = [
        0,  50, 100,
        0,  50, 100,
        0,  50, 100]
    expect_data_blue = [
        0,   0,   0,
        0,   0,   0,
        0,   0,   0]
    expect_width=3
    expect_height=3

    assert_equal @match_top_left_with_alpha_bitmap.data_red,   expect_data_red
    assert_equal @match_top_left_with_alpha_bitmap.data_green, expect_data_green
    assert_equal @match_top_left_with_alpha_bitmap.data_blue,  expect_data_blue
    assert_equal @match_top_left_with_alpha_bitmap.width,      expect_width
    assert_equal @match_top_left_with_alpha_bitmap.height,     expect_height
  end

  def test_match_top_right_with_alpha_bitmap
    expect_data_red = [
        0,   0,   0,
       50,  50,  50,
      100, 100, 100]
    expect_data_green = [
      100, 150, 200,
      100, 150, 200,
      100, 150, 200]
    expect_data_blue = [
        0,   0,   0,
        0,   0,   0,
        0,   0,   0]
    expect_width=3
    expect_height=3

    assert_equal @match_top_right_with_alpha_bitmap.data_red,   expect_data_red
    assert_equal @match_top_right_with_alpha_bitmap.data_green, expect_data_green
    assert_equal @match_top_right_with_alpha_bitmap.data_blue,  expect_data_blue
    assert_equal @match_top_right_with_alpha_bitmap.width,      expect_width
    assert_equal @match_top_right_with_alpha_bitmap.height,     expect_height
  end

  def test_match_center_with_alpha_bitmap
    expect_data_red = [
       50,  50,  50,
      100, 100, 100,
      150, 150, 150]
    expect_data_green = [
       50, 100, 150,
       50, 100, 150,
       50, 100, 150]
    expect_data_blue = [
        0,   0,   0,
        0,   0,   0,
        0,   0,   0]
    expect_width=3
    expect_height=3

    assert_equal @match_center_with_alpha_bitmap.data_red,   expect_data_red
    assert_equal @match_center_with_alpha_bitmap.data_green, expect_data_green
    assert_equal @match_center_with_alpha_bitmap.data_blue,  expect_data_blue
    assert_equal @match_center_with_alpha_bitmap.width,      expect_width
    assert_equal @match_center_with_alpha_bitmap.height,     expect_height
  end

  def test_no_match_with_alpha_bitmap
    expect_data_red = [
      250, 250, 250,
      250, 250, 250,
      250, 250, 250]
    expect_data_green = [
      250, 250, 250,
      250, 250, 250,
      250, 250, 250]
    expect_data_blue = [
      250, 250, 250,
      250, 250, 250,
      250, 250, 250]
    expect_width=3
    expect_height=3

    assert_equal @no_match_with_alpha_bitmap.data_red,   expect_data_red
    assert_equal @no_match_with_alpha_bitmap.data_green, expect_data_green
    assert_equal @no_match_with_alpha_bitmap.data_blue,  expect_data_blue
    assert_equal @no_match_with_alpha_bitmap.width,      expect_width
    assert_equal @no_match_with_alpha_bitmap.height,     expect_height
  end

  def test_filtered_base_bitmap
    expect_data_red = [
        0,   0,   0,  77, 211, 168,   0,   0,   0,   0,   0,
        0,   1,   0,  78, 210, 167,   0,   1,   0,   0,   0,
        0,   0,   0,  77, 210, 168,   1,   0,   0,   0,   0,
       94, 208, 207, 210, 210, 210, 208, 209, 208, 209, 106,
       89, 196, 196, 205, 210, 210, 196, 196, 195, 196,  99,
        0,   0,   0,  77, 210, 172,   0,   0,   1,   0,   0,
        1,   0,   0,  78, 211, 171,   0,   0,   0,   0,   0,
        0,   0,   0,  77, 210, 172,   0,   0,   1,   0,   0,
        0,   1,   0,  77, 210, 173,   0,   0,   1,   0,   0,
        0,   0,   0,  76, 210, 172,   0,   0,   0,   0,   0,
        0,   0,   0,  76, 210, 173,   0,   0,   1,   0,   0,
        0,   0,   0,  75, 210, 197,   9,   0,   0,   0,   1,
        1,   0,   0,  48, 210, 210, 119,  28,   0,   0,   0,
        0,   0,   0,   3, 173, 210, 210, 210, 195, 196,  93,
        0,   0,   0,   1,  21, 133, 191, 210, 210, 210, 101]
    expect_data_green = [
        0,   1,   0,  16,  45,  35,   0,   1,   1,   0,   0,
        0,   0,   0,  15,  46,  36,   0,   1,   0,   0,   0,
        0,   0,   0,  16,  46,  36,   0,   0,   0,   0,   0,
       20,  44,  44,  45,  44,  46,  43,  44,  44,  45,  22,
       19,  42,  42,  43,  45,  45,  42,  42,  42,  42,  21,
        0,   0,   1,  16,  45,  38,   0,   0,   0,   0,   0,
        0,   0,   0,  16,  45,  37,   0,   1,   0,   0,   0,
        0,   0,   0,  16,  45,  37,   0,   0,   0,   1,   1,
        1,   0,   0,  16,  46,  37,   0,   0,   0,   0,   0,
        0,   0,   0,  16,  45,  36,   0,   0,   0,   0,   0,
        0,   0,   1,  15,  46,  37,   0,   0,   0,   0,   0,
        0,   0,   0,  15,  46,  41,   2,   0,   0,   1,   0,
        0,   0,   0,  10,  45,  46,  25,   5,   0,   0,   0,
        0,   0,   1,   0,  38,  44,  45,  46,  41,  42,  19,
        0,   0,   0,   0,   4,  28,  40,  45,  45,  44,  21]
    expect_data_blue = [
        1,   0,   1,  80, 222, 176,   1,   0,   0,   0,   0,
        0,   0,   0,  81, 223, 177,   0,   0,   0,   0,   1,
        0,   0,   1,  81, 222, 177,   0,   0,   0,   0,   0,
      100, 219, 221, 221, 222, 222, 221, 221, 219, 220, 113,
       94, 208, 208, 216, 222, 222, 208, 208, 208, 208, 105,
        1,   0,   0,  82, 222, 182,   0,   0,   0,   0,   1,
        0,   0,   0,  80, 223, 183,   1,   0,   0,   0,   0,
        1,   0,   0,  80, 222, 182,   0,   0,   0,   0,   0,
        0,   1,   0,  81, 223, 182,   0,   0,   0,   0,   0,
        0,   0,   0,  81, 222, 182,   0,   0,   0,   0,   0,
        0,   0,   0,  81, 222, 182,   1,   0,   1,   0,   0,
        0,   0,   0,  78, 222, 208,  10,   1,   0,   0,   1,
        0,   1,   0,  51, 222, 222, 126,  28,   0,   0,   1,
        0,   0,   0,   3, 184, 222, 222, 222, 206, 208,  98,
        0,   0,   0,   0,  23, 141, 201, 222, 222, 223, 105]
    expect_width=11
    expect_height=15

    assert_equal @filtered_base_bitmap.data_red,   expect_data_red
    assert_equal @filtered_base_bitmap.data_green, expect_data_green
    assert_equal @filtered_base_bitmap.data_blue,  expect_data_blue
    assert_equal @filtered_base_bitmap.width,      expect_width
    assert_equal @filtered_base_bitmap.height,     expect_height
  end

  def test_filtered_template_bitmap
    expect_data_red = [
        0,   1,   0,  77, 210, 168,   0,   1,   1,   0,   0,
        0,   0,   0,  77, 210, 167,   0,   0,   0,   0,   1,
       94, 208, 207, 210, 210, 211, 208, 208, 207, 208, 106,
       89, 196, 196, 205, 210, 210, 196, 196, 197, 196,  99,
        1,   0,   0,  77, 209, 173,   0,   0,   0,   0,   0,
        0,   0,   1,  77, 210, 172,   0,   0,   0,   0,   0,
        0,   0,   1,  76, 210, 172,   0,   0,   0,   0,   0,
        0,   0,   0,  77, 210, 171,   0,   1,   0,   0,   1,
        0,   0,   0,  77, 211, 172,   0,   0,   0,   0,   0,
        0,   0,   0,  76, 210, 172,   0,   0,   1,   0,   0,
        0,   0,   0,  74, 210, 197,   9,   0,   0,   0,   1,
        0,   0,   0,  47, 210, 210, 119,  27,   0,   0,   1,
        1,   0,   0,   3, 174, 210, 210, 211, 195, 196,  93,
        0,   0,   0,   0,  22, 133, 190, 210, 210, 210, 100]
    expect_data_green = [
        1,   0,   0,  16,  45,  36,   0,   0,   0,   0,   0,
        0,   0,   0,  16,  45,  36,   0,   0,   1,   0,   0,
       20,  44,  44,  44,  45,  45,  44,  44,  44,  44,  23,
       18,  43,  42,  43,  45,  46,  42,  42,  42,  42,  21,
        0,   0,   0,  17,  44,  37,   0,   0,   1,   1,   0,
        0,   0,   0,  16,  44,  38,   0,   0,   0,   0,   0,
        1,   1,   0,  16,  45,  38,   0,   1,   0,   0,   0,
        0,   0,   0,  16,  45,  37,   0,   0,   0,   0,   0,
        0,   0,   0,  16,  45,  36,   0,   0,   0,   0,   0,
        1,   0,   0,  16,  45,  37,   1,   0,   0,   0,   0,
        0,   1,   0,  16,  45,  42,   1,   0,   0,   0,   1,
        0,   0,   0,   9,  45,  44,  26,   4,   0,   0,   0,
        1,   0,   0,   0,  38,  45,  45,  45,  41,  42,  19,
        0,   0,   1,   0,   5,  28,  40,  46,  45,  45,  21]
    expect_data_blue = [
        0,   0,   0,  81, 222, 177,   0,   0,   1,   0,   0,
        0,   0,   0,  81, 222, 176,   0,   0,   0,   0,   0,
      100, 221, 220, 222, 222, 223, 220, 220, 220, 220, 112,
       93, 208, 208, 216, 223, 222, 207, 208, 209, 208, 104,
        0,   1,   0,  81, 221, 182,   1,   0,   0,   0,   1,
        0,   0,   0,  82, 222, 181,   0,   1,   0,   0,   0,
        0,   0,   0,  81, 222, 183,   0,   0,   0,   0,   0,
        1,   0,   0,  80, 222, 182,   0,   0,   0,   1,   0,
        0,   0,   0,  81, 222, 182,   0,   0,   0,   0,   0,
        0,   0,   0,  81, 223, 182,   0,   0,   0,   0,   0,
        1,   1,   0,  77, 222, 208,  10,   0,   0,   1,   0,
        0,   0,   0,  52, 222, 222, 126,  28,   0,   0,   0,
        0,   0,   0,   3, 184, 222, 222, 221, 206, 207,  97,
        0,   1,   1,   0,  21, 142, 201, 222, 223, 222, 107]
    expect_width=11
    expect_height=14

    assert_equal @filtered_template_bitmap.data_red,   expect_data_red
    assert_equal @filtered_template_bitmap.data_green, expect_data_green
    assert_equal @filtered_template_bitmap.data_blue,  expect_data_blue
    assert_equal @filtered_template_bitmap.width,      expect_width
    assert_equal @filtered_template_bitmap.height,     expect_height
  end

  def test_template_match_base_and_match_top_left
    matched, matchX, matchY = Katanuki::templateMatch(@base_bitmap, @match_top_left_bitmap)
    assert_equal matched, true
    assert_equal matchX,  0
    assert_equal matchY,  0
  end

  def test_template_match_base_and_match_top_right
    matched, matchX, matchY = Katanuki::templateMatch(@base_bitmap, @match_top_right_bitmap)
    assert_equal matched, true
    assert_equal matchX,  2
    assert_equal matchY,  0
  end

  def test_template_match_base_and_match_bottom_left
    matched, matchX, matchY = Katanuki::templateMatch(@base_bitmap, @match_bottom_left_bitmap)
    assert_equal matched, true
    assert_equal matchX,  0
    assert_equal matchY,  2
  end

  def test_template_match_base_and_match_bottom_right
    matched, matchX, matchY = Katanuki::templateMatch(@base_bitmap, @match_bottom_right_bitmap)
    assert_equal matched, true
    assert_equal matchX,  2
    assert_equal matchY,  2
  end

  def test_template_match_base_and_match_center
    matched, matchX, matchY = Katanuki::templateMatch(@base_bitmap, @match_center_bitmap)
    assert_equal matched, true
    assert_equal matchX,  1
    assert_equal matchY,  1
  end

  def test_template_match_base_and_no_match
    matched, matchX, matchY = Katanuki::templateMatch(@base_bitmap, @no_match_bitmap)
    assert_equal matched, false
    assert_equal matchX,  0
    assert_equal matchY,  0
  end

  def test_template_match_base_and_base
    matched, matchX, matchY = Katanuki::templateMatch(@base_bitmap, @base_bitmap)
    assert_equal matched, true
    assert_equal matchX,  0
    assert_equal matchY,  0
  end

  def test_template_match_match_bottom_left_and_base
    matched, matchX, matchY = Katanuki::templateMatch(@match_bottom_left_bitmap, @base_bitmap)
    assert_equal matched, false
    assert_equal matchX,  0
    assert_equal matchY,  0
  end

  def test_template_match_base8x4_and_match_bottom_right4x1
    matched, matchX, matchY = Katanuki::templateMatch(@base8x4_bitmap, @match_bottom_right4x1_bitmap)
    assert_equal matched, true
    assert_equal matchX,  4
    assert_equal matchY,  3
  end

  def test_template_match_base4x8_and_match_bottom_right1x4
    matched, matchX, matchY = Katanuki::templateMatch(@base4x8_bitmap, @match_bottom_right1x4_bitmap)
    assert_equal matched, true
    assert_equal matchX,  3
    assert_equal matchY,  4
  end

  def test_sub_filtered_base_bitmap
    expect_data_red = [
        0,   0,   0,   0,   0,
       50,  50,  50,  50,  50,
      100, 100, 100, 100, 100,
      150, 150, 150, 150, 150,
      200, 200, 200, 200, 200]
    expect_data_green = [
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200]
    expect_data_blue = [
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0]
    expect_width=5
    expect_height=5

    assert_equal @sub_filtered_base_bitmap.data_red,   expect_data_red
    assert_equal @sub_filtered_base_bitmap.data_green, expect_data_green
    assert_equal @sub_filtered_base_bitmap.data_blue,  expect_data_blue
    assert_equal @sub_filtered_base_bitmap.width,      expect_width
    assert_equal @sub_filtered_base_bitmap.height,     expect_height
  end

  def test_up_filtered_base_bitmap
    expect_data_red = [
        0,   0,   0,   0,   0,
       50,  50,  50,  50,  50,
      100, 100, 100, 100, 100,
      150, 150, 150, 150, 150,
      200, 200, 200, 200, 200]
    expect_data_green = [
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200]
    expect_data_blue = [
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0]
    expect_width=5
    expect_height=5

    assert_equal @up_filtered_base_bitmap.data_red,   expect_data_red
    assert_equal @up_filtered_base_bitmap.data_green, expect_data_green
    assert_equal @up_filtered_base_bitmap.data_blue,  expect_data_blue
    assert_equal @up_filtered_base_bitmap.width,      expect_width
    assert_equal @up_filtered_base_bitmap.height,     expect_height
  end

  def test_avg_filtered_base_bitmap
    expect_data_red = [
        0,   0,   0,   0,   0,
       50,  50,  50,  50,  50,
      100, 100, 100, 100, 100,
      150, 150, 150, 150, 150,
      200, 200, 200, 200, 200]
    expect_data_green = [
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200]
    expect_data_blue = [
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0]
    expect_width=5
    expect_height=5

    assert_equal @avg_filtered_base_bitmap.data_red,   expect_data_red
    assert_equal @avg_filtered_base_bitmap.data_green, expect_data_green
    assert_equal @avg_filtered_base_bitmap.data_blue,  expect_data_blue
    assert_equal @avg_filtered_base_bitmap.width,      expect_width
    assert_equal @avg_filtered_base_bitmap.height,     expect_height
  end

  def test_paeth_filtered_base_bitmap
    expect_data_red = [
        0,   0,   0,   0,   0,
       50,  50,  50,  50,  50,
      100, 100, 100, 100, 100,
      150, 150, 150, 150, 150,
      200, 200, 200, 200, 200]
    expect_data_green = [
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200,
        0,  50, 100, 150, 200]
    expect_data_blue = [
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0,
        0,   0,   0,   0,   0]
    expect_width=5
    expect_height=5

    assert_equal @paeth_filtered_base_bitmap.data_red,   expect_data_red
    assert_equal @paeth_filtered_base_bitmap.data_green, expect_data_green
    assert_equal @paeth_filtered_base_bitmap.data_blue,  expect_data_blue
    assert_equal @paeth_filtered_base_bitmap.width,      expect_width
    assert_equal @paeth_filtered_base_bitmap.height,     expect_height
  end


  def test_template_match_filtered_base_and_filtered_template
    matched, matchX, matchY = Katanuki::templateMatch(@filtered_base_bitmap, @filtered_template_bitmap)
    assert_equal matched, true
    assert_equal matchX,  0
    assert_equal matchY,  1
  end

end
