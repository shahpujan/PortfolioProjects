-- Cleaning data in SQL Queries

select * from PortfolioProject..NashvilleHousing

-- Standardize the data format...

select SaleDate,CONVERT(Date,SaleDate) 
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
add SaleDateConverted Date;

update PortfolioProject..NashvilleHousing
set SaleDateConverted = CONVERT(Date,SaleDate)

select * from PortfolioProject..NashvilleHousing

--- Populate null Property Address data

select * from PortfolioProject ..NashvilleHousing
-- where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject ..NashvilleHousing a
join PortfolioProject ..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]	
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject ..NashvilleHousing a
join PortfolioProject ..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]	
where a.PropertyAddress is null

-----Breaking out Address into Individual Columns(Address,City,State)

select PropertyAddress
from PortfolioProject ..NashvilleHousing

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) as Subaddress,
from PortfolioProject ..NashvilleHousing

Alter table PortfolioProject ..NashvilleHousing
Add PropertySplitCity nvarchar(255);

Alter table PortfolioProject ..NashvilleHousing
Add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))


select *
from 
PortfolioProject ..NashvilleHousing

select OwnerAddress
from PortfolioProject ..NashvilleHousing;

select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject ..NashvilleHousing;

Alter table PortfolioProject ..NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Alter table PortfolioProject ..NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Alter table PortfolioProject ..NashvilleHousing
Add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


select *
from PortfolioProject ..NashvilleHousing;

-----------------
--Change Y and N to Yes and No

select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject ..NashvilleHousing
group by SoldAsVacant
order by 2;

select SoldAsVacant,
case when SoldAsVacant ='Y' THEN 'Yes'
	 when SoldAsVacant = 'N' THEN 'No'
	 else SoldAsVacant
end
from PortfolioProject ..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant ='Y' THEN 'Yes'
						when SoldAsVacant = 'N' THEN 'No'
						else SoldAsVacant
end


---Removing the duplicates
WITH RowNumCTE AS(
select * ,
	ROW_NUMBER() over(
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by UniqueID) as row_num
from PortfolioProject .. NashvilleHousing
--order by ParcelID
)
Select * 
from RowNumCTE
where row_num > 1
order by PropertyAddress

-----Delete Unused Columns

select * 
from PortfolioProject .. NashvilleHousing

alter table PortfolioProject .. NashvilleHousing
drop column OwnerAddress,PropertyAddress,TaxDistrict,SaleDate