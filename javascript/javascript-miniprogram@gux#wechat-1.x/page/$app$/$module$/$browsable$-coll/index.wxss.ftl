@import "/app.wxss";

.product-card {
  border: none;
  border-radius: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  background-color: white;
  overflow: hidden;
}

.product-card img {
  border-top-left-radius: 15px;
  border-top-right-radius: 15px;
  width: 100%;
}

.product-card .card-body {
  padding: 10px;
}

.product-card .sale-badge {
  position: absolute;
  top: 15px;
  left: 15px;
  background-color: orange;
  color: white;
  padding: 5px 10px;
  border-radius: 5px;
  font-size: 0.9rem;
  font-weight: bold;
}

.product-card .product-price {
  display: flex;
  align-items: center;
  font-weight: bold;
  font-size: 1.2rem;
}

.product-card .product-price .price-icon {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-color: #f5f5f5;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 10px;
}

.product-card .card-footer {
  background-color: #f5f5f5;
  border-top: none;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  border-bottom-left-radius: 15px;
  border-bottom-right-radius: 15px;
}

.product-card .icon {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-color: #e9ecef;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.product-card .icon image {
  width: 16px;
  height: 16px;
}

.product-card .badge-verified {
  position: absolute;
  top: 20px;
  right: 20px;
  background-color: #e0f7fa;
  color: #26a69a;
  font-weight: bold;
  padding: 5px 10px;
  border-radius: 12px;
}

.product-card .rating {
  display: flex;
  justify-content: center;
  margin-bottom: 10px;
}

.product-card .rating text {
  color: #ff9800;
  margin: 0 2px;
}

.product-card .rating text:last-child {
  color: #ccc;
}

.product-card .list {
  list-style: none;
  padding: 0;
  margin: 20px 0;
  text-align: left;
}

.product-card .list .list-item  {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.product-card .list .list-item text {
  color: #4caf50;
  margin-right: 10px;
}

.product-card .btn-purchase {
  background-color: #007bff;
  color: white;
  border-radius: 25px;
  padding: 10px 20px;
  font-weight: bold;
}
