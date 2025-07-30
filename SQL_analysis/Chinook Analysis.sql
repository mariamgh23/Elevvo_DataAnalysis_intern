--Revenue by country 
SELECT 
    BillingCountry, 
    SUM(Total) AS Revenue
FROM 
    dbo.Invoice
GROUP BY 
    BillingCountry
ORDER BY 
    Revenue DESC;


--Top-Selling Artists
SELECT 
    ar.Name, 
    COUNT(il.Quantity) AS TracksSold,  
    SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM 
    dbo.Artist ar
JOIN 
    dbo.Album al ON ar.ArtistId = al.ArtistId
JOIN 
    dbo.Track t ON al.AlbumId = t.AlbumId
JOIN 
    dbo.InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY 
    ar.Name
ORDER BY 
    Revenue DESC;


--. Customer Purchase Frequency
SELECT 
    CustomerId, 
    COUNT(*) AS PurchaseCount,  
    AVG(Total) AS AvgOrderValue
FROM 
    dbo.Invoice
GROUP BY 
    CustomerId;










--Total revenue by country, customer, genre
SELECT 
    c.Country,
    c.CustomerId,
    c.FirstName,
    c.LastName,
    g.Name AS Genre,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM 
    dbo.Customer c
JOIN 
    dbo.Invoice i ON c.CustomerId = i.CustomerId
JOIN 
    dbo.InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN 
    dbo.Track t ON il.TrackId = t.TrackId
JOIN 
    dbo.Genre g ON t.GenreId = g.GenreId
GROUP BY 
    c.Country, c.CustomerId, c.FirstName, c.LastName, g.Name
ORDER BY 
    c.Country, c.CustomerId, g.Name;

	--Best-selling tracks, albums, and artists
	--albums
	SELECT al.Title AS AlbumTitle,
	SUM(il.UnitPrice*il.Quantity) AS TotalRevenue
	FROM dbo.InvoiceLine il
	JOIN dbo.Track t ON il.TrackId=t.TrackId
	JOIN dbo.Album al ON t.AlbumId=al.AlbumId
	GROUP BY al.Title
	ORDER BY TotalRevenue DESC;
    --Tracks
	SELECT t.Name AS TracKName,
	SUM(il.UnitPrice*il.Quantity) AS TotalRevenue
	FROM dbo.InvoiceLine il
	JOIN dbo.Track t ON il.TrackId=t.TrackId
	GROUP BY t.Name
	ORDER BY TotalRevenue DESC;
	--Artist
	SELECT ar.Name AS ArtistName,
	SUM(il.UnitPrice*IL.Quantity)AS TotalRevenue
	FROM dbo.InvoiceLine il
	JOIN dbo.Track t ON il.TrackId=t.TrackId
	JOIN dbo.Album al ON t.AlbumId=al.AlbumId
	JOIN dbo.Artist ar ON al.ArtistId=ar.ArtistId
	GROUP BY ar.Name
	ORDER BY TotalRevenue DESC;

	--Monthly/yearly sales trends
	--Monthly
	SELECT YEAR(i.InvoiceDate) AS SalesYear,
	Month(i.InvoiceDate) AS SalesMonth,
	SUM(il.UnitPrice*il.Quantity) AS TotalRevenue
    FROM dbo.Invoice i
	JOIN dbO.InvoiceLine il ON i.InvoiceId=il.InvoiceId
	GROUP BY YEAR(i.InvoiceDate),Month(i.InvoiceDate)
	ORDER BY 
    SalesYear, SalesMonth;


	--Average Order Value(AOV)
	SELECT 
    AVG(OrderTotal) AS AverageOrderValue
FROM (
    SELECT 
        i.InvoiceId,
        SUM(il.UnitPrice * il.Quantity) AS OrderTotal
    FROM 
        dbo.Invoice i
    JOIN 
        dbo.InvoiceLine il ON i.InvoiceId = il.InvoiceId
    GROUP BY 
        i.InvoiceId
) AS OrderTotals;

-- Customer Lifetime Value (CLV)
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    SUM(il.UnitPrice * il.Quantity) AS LifetimeValue
FROM 
    dbo.Customer c
JOIN 
    dbo.Invoice i ON c.CustomerId = i.CustomerId
JOIN 
    dbo.InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY 
    c.CustomerId, c.FirstName, c.LastName
ORDER BY 
    LifetimeValue DESC;

	--Customer Segmentation by Purchase Patterns
	SELECT 
    c.CustomerId,
    MAX(i.InvoiceDate) AS LastPurchaseDate,
    COUNT(i.InvoiceId) AS PurchaseFrequency,
    SUM(il.UnitPrice * il.Quantity) AS MonetaryValue
FROM 
    dbo.Customer c
JOIN 
    dbo.Invoice i ON c.CustomerId = i.CustomerId
JOIN 
    dbo.InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY 
    c.CustomerId;

-- Geographic Distribution of Customers
SELECT 
    Country,
    COUNT(*) AS CustomerCount
FROM 
    dbo.Customer
GROUP BY 
    Country
ORDER BY 
    CustomerCount DESC;

-- Most Popular Genres by Customer Demographics
SELECT 
    c.Country,
    g.Name AS Genre,
    COUNT(*) AS PurchaseCount
FROM 
    dbo.Customer c
JOIN 
    dbo.Invoice i ON c.CustomerId = i.CustomerId
JOIN 
    dbo.InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN 
    dbo.Track t ON il.TrackId = t.TrackId
JOIN 
    dbo.Genre g ON t.GenreId = g.GenreId
GROUP BY 
    c.Country, g.Name
ORDER BY 
    c.Country, PurchaseCount DESC;

--Product Analysis:

--Track length vs. popularity correlation
SELECT 
    t.Name AS TrackName,
    t.Milliseconds / 60000.0 AS TrackLengthMinutes,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM 
    dbo.Track t
JOIN 
    dbo.InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY 
    t.Name, t.Milliseconds
ORDER BY 
    TotalRevenue DESC;

-- Genre Performance Comparison
SELECT 
    g.Name AS Genre,
    COUNT(*) AS TrackSalesCount,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM 
    dbo.Genre g
JOIN 
    dbo.Track t ON g.GenreId = t.GenreId
JOIN 
    dbo.InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY 
    g.Name
ORDER BY 
    TotalRevenue DESC;

--Album VS Individual Tracks Sales
SELECT 
    al.Title AS AlbumTitle,
    COUNT(il.InvoiceLineId) AS TrackSalesCount,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM 
    dbo.Album al
JOIN 
    dbo.Track t ON al.AlbumId = t.AlbumId
JOIN 
    dbo.InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY 
    al.Title
ORDER BY 
    TotalRevenue DESC;

--Media Type Preferences
SELECT 
    mt.Name AS MediaType,
    COUNT(*) AS PurchaseCount,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM 
    dbo.MediaType mt
JOIN 
    dbo.Track t ON mt.MediaTypeId = t.MediaTypeId
JOIN 
    dbo.InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY 
    mt.Name
ORDER BY 
    TotalRevenue DESC;