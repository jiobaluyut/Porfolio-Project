--- Cleaning Data in SQL queries

Select*
From [Portfolio Project].dbo.NashvilleHousing

-----Standardize Date Format----- 

Select SaleDateConverted, CONVERT(Date,SaleDate)
From [Portfolio Project].dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-----Populate Property Address Data----- 

Select *
From [Portfolio Project].dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select NHA.ParcelID, NHA.PropertyAddress, NHB.ParcelID, NHB.PropertyAddress, ISNULL(NHA.PropertyAddress,NHB.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing  NHA
JOIN [Portfolio Project].dbo.NashvilleHousing  NHB
	on NHA.ParcelID = NHB.ParcelID
	AND NHA.[UniqueID ] <> NHB.[UniqueID ]
Where NHA.PropertyAddress is null


Update	NHA
SET PropertyAddress = ISNULL(NHA.PropertyAddress,NHB.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing  NHA
JOIN [Portfolio Project].dbo.NashvilleHousing  NHB
	on NHA.ParcelID = NHB.ParcelID
	AND NHA.[UniqueID ] <> NHB.[UniqueID ]
Where NHA.PropertyAddress is null


-----Breaking Out Address (Adress, City, State)----- 

Select PropertyAddress
From [Portfolio Project].dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))  as Address

From [Portfolio Project].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))





SELECT *
From [Portfolio Project].dbo.NashvilleHousing



SELECT OwnerAddress
From [Portfolio Project].dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3) as Street
,PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2) as City
,PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1) as State
From [Portfolio Project].dbo.NashvilleHousing


--OwnerSplitAddress--
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3) 


--OwnerSplitCity--
ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2) 


--OwnerSplitState--
ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1) 



SELECT *
From [Portfolio Project].dbo.NashvilleHousing





------ Change Y and N to Yes and No in 'SoldasVacant)-----

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project].dbo.NashvilleHousing
Group By SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From [Portfolio Project].dbo.NashvilleHousing



Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END 




-----Remove Duplicates-----

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

From [Portfolio Project].dbo.NashvilleHousing
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
Order by PropertyAddress





Select *
From [Portfolio Project].dbo.NashvilleHousing







-----Delete Unused Columns-----



Select *
From [Portfolio Project].dbo.NashvilleHousing


ALTER TABLE	[Portfolio Project].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE	[Portfolio Project].dbo.NashvilleHousing
DROP COLUMN SaleDate