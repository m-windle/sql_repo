/***************************
*     Masatoshi Windle     *
*         100913032        *
***************************/

--1
/*Inserts a new category with the specified name and 
  the next value in the category id sequence*/
CREATE OR REPLACE PROCEDURE insert_category(
  cat_name varchar2
)
AS
BEGIN 
  INSERT INTO categories (category_id, category_name)
    VALUES (CATEGORY_ID_SEQ.NEXTVAL, cat_name);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('That category exists!');
    ROLLBACK;
END;
/

SET SERVEROUTPUT ON;
CALL insert_category('Drums');
CALL insert_category('Brass');

--2
/*Returns the discount price of the item_id specified*/
CREATE OR REPLACE FUNCTION discount_price(
  input_id NUMBER
)
RETURN NUMBER
AS
  disc_price NUMBER;
BEGIN
  SELECT (item_price - discount_amount) INTO disc_price
  FROM order_items
  WHERE item_id = input_id;
  
  RETURN disc_price;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error occurred!');
END;
/

--Test Select Statement
SELECT discount_price(1) AS Discount_Price FROM DUAL;

--3
/*Prevent a discount percent greater than 100 or less than 0
  and converts decimal percentages to whole values*/
CREATE OR REPLACE TRIGGER products_before_update
BEFORE UPDATE 
  ON products
  FOR EACH ROW
BEGIN
  IF :new.discount_percent > 100 OR :new.discount_percent < 0 THEN
    RAISE VALUE_ERROR;
  END IF;
  IF :new.discount_percent > 0 AND :new.discount_percent < 1 THEN
    :new.discount_percent := :new.discount_percent * 100;
  END IF;
EXCEPTION
  WHEN VALUE_ERROR THEN
    :new.discount_percent := :old.discount_percent;
    DBMS_OUTPUT.PUT_LINE('Invalid Percentage!');
END;
/

--Test Update Statements
UPDATE products 
SET discount_percent = 110
WHERE product_id = 1;

UPDATE products
SET discount_percent = 0.3
WHERE product_id = 1;

--4
/*If date_added column is null in a products row
  date_added is set to sysdate (i.e. Current Date)*/
CREATE OR REPLACE TRIGGER products_before_insert
BEFORE INSERT
  ON products
  FOR EACH ROW
BEGIN
  IF :new.date_added IS NULL THEN
    :new.date_added := SYSDATE;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Database error has occured');
END;
/

--Test Insert statement
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, discount_percent, date_added)
VALUES (PRODUCT_ID_SEQ.NEXTVAL, 1, 'test', 'tester', 'This is a new test', 20, 100, NULL);