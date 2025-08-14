package model

import "time"

type SubsInitialPayment struct {
	AcctNo       string     `gorm:"column:ACCTNO;primaryKey" json:"acctNo"`
	TranNo       string     `gorm:"column:TRANNO" json:"tranNo"`
	TranTypeCode *int64     `gorm:"column:TRANTYPECODE" json:"tranTypeCode"`
	ArTypeCode   string     `gorm:"column:ARTYPECODE" json:"arTypeCode"`
	TranDate     *time.Time `gorm:"column:TRANDATE" json:"tranDate"`
	Priority     int64      `gorm:"column:PRIORITY" json:"priority"`
	Amount       int64      `gorm:"column:AMOUNT" json:"amount"`
	PaidAmt      int64      `gorm:"column:PAIDAMT" json:"paidAmt"`
	Balance      int64      `gorm:"column:BALANCE" json:"Balance"`
	Processed    string     `gorm:"column:PROCESSED" json:"Processed"`
	DateAdd      *time.Time `gorm:"column:DATEADD" json:"dateAdd"`
	Cancelled    string     `gorm:"column:CANCELLED" json:"cancelled"`
	ID           int64      `gorm:"column:ID" json:"id" example:"1001"`
	DivisionCode string     `gorm:"column:DIVISIONCODE;primaryKey" json:"divisionCode" example:"DV001"`
	CompanyCode  string     `gorm:"column:COMPANYCODE;primaryKey" json:"companyCode" example:"CP001"`
}

// TableName overrides the default table name
func (SubsInitialPayment) TableName() string {
	return "IBAS.SUBSINITIALPAYMENT"
}
