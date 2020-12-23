class Location < ApplicationRecord
  # ให้สร้าง location ตามคลังสินค้าที่ใช้เก็บสินค้าจริงๆ
  # จากนั้นให้กำหนดว่าเป็น available หรือ not available
  # ทุกครั้งที่มีการนำสินค้าเข้า stock ต้องกำหนดด้วยว่าอยู่ที่ location ไหน
end
