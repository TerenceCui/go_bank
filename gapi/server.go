package gapi

import (
	"fmt"
	"github.com/TerenceCui/go_bank/worker"

	db "github.com/TerenceCui/go_bank/db/sqlc"
	"github.com/TerenceCui/go_bank/pb"
	"github.com/TerenceCui/go_bank/token"
	"github.com/TerenceCui/go_bank/util"
)

type Server struct {
	pb.UnimplementedBankServer
	config          util.Config
	store           db.Store
	tokenMaker      token.Maker
	taskDistributor worker.TaskDistributor
}

func NewServer(config util.Config, store db.Store, taskDistributor worker.TaskDistributor) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}

	server := &Server{
		config:          config,
		store:           store,
		tokenMaker:      tokenMaker,
		taskDistributor: taskDistributor,
	}

	return server, nil
}
