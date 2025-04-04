CREATE PROCEDURE orderProduct_SP
    @userId INT,
    @addressId INT,
    @generatedUuid VARCHAR(150),
    @cardPart VARCHAR(4),
    @orderType VARCHAR(16),
    @fldProductId VARCHAR(128) = NULL,
    @fldQuantity INT = NULL,           
    @fldPrice DECIMAL(10,2) = NULL,    
    @fldTax DECIMAL(10,2) = NULL       
AS
BEGIN
    DECLARE @totalPrice DECIMAL(10,2),
            @totalTax DECIMAL(10,2);

    BEGIN TRANSACTION;
    BEGIN TRY
        IF @orderType = 'FROM_CART'
        BEGIN
            SELECT
                @totalPrice = SUM(tc.fldQuantity * tp.fldPrice),
                @totalTax = SUM(tc.fldQuantity * (tp.fldPrice * tp.fldTax) / 100)
            FROM 
                tblCart AS tc
            INNER JOIN
                tblProduct AS tp ON tc.fldProductId = tp.fldProduct_ID
            WHERE 
                tc.fldUserId = @userId;
        END
        ELSE IF @orderType = 'BUY_NOW'
        BEGIN
            SET @totalPrice = @fldPrice * @fldQuantity;
            SET @totalTax = ((@fldPrice * @fldTax) / 100) * @fldQuantity;
        END

        INSERT INTO tblOrder
            (
                fldOrder_ID,
                fldUserId,
                fldAddressId,
                fldTotalPrice,
                fldTotalTax,
                fldCardPart
            )
        VALUES
            (
                @generatedUuid,
                @userId,
                @addressId,
                @totalPrice,
                @totalTax,
                @cardPart
            );

        IF @orderType = 'FROM_CART'
        BEGIN
            INSERT INTO tblOrderedItems
                (
                    fldOrderId,
                    fldProductId,
                    fldQuantity,
                    fldUnitPrice,
                    fldUnitTax
                )
            SELECT
                @generatedUuid,
                tc.fldProductId,
                tc.fldQuantity,
                tp.fldPrice,
                tp.fldTax
            FROM 
                tblCart AS tc
            INNER JOIN
                tblProduct AS tp ON tc.fldProductId = tp.fldProduct_ID
            WHERE 
                tc.fldUserId = @userId;

            DELETE FROM tblCart WHERE fldUserId = @userId;
        END
        ELSE IF @orderType = 'BUY_NOW'
        BEGIN
            INSERT INTO tblOrderedItems
                (
                    fldOrderId,
                    fldProductId,
                    fldQuantity,
                    fldUnitPrice,
                    fldUnitTax
                )
            VALUES
                (
                    @generatedUuid,
                    @fldProductId,
                    @fldQuantity,
                    @fldPrice,
                    @fldTax
                );
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'An error occurred. Transaction rolled back.';
    END CATCH;
END;
