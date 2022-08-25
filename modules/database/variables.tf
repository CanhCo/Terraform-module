variable "project" {
  type = string
}

variable "vpc" {
  type = any
}

variable "sg" {
  type = any
}

#khi muốn truyền giá trị mà không biết nó thuộc loại dữ liệu nào, thì ta sẽ khai báo kiểu dữ liệu là any