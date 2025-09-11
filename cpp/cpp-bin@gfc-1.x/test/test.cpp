// test_main.cpp
#include <gtest/gtest.h>


// 测试 add 函数
TEST(AdditionTest, HandlesPositiveInput) {

}

// 测试 subtract 函数
TEST(SubtractionTest, HandlesPositiveInput) {
  EXPECT_EQ(1, 0);
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
